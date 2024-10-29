
local config = {
  update_interval = 60000,        -- 60 seconds
  max_length = 80,                -- Maximum visible length for ticker
  ticker_update_interval = 150,   -- Speed of ticker update
  max_fortune_length = 300,       -- Maximum allowed length of fortune messages
  enabled = true                  -- Enable/disable fortune display
}

local fortune = {
  last = "",
  last_update_time = 0,
  ticker_position = 0,
}

local ticker_timer = vim.loop.new_timer()

local function update_fortune(force)
  local current_time = vim.loop.now()
  if force or current_time - fortune.last_update_time > config.update_interval then
    local handle = io.popen("fortune -s", "r")
    if handle then
      local result = handle:read("*a")
      handle:close()
      result = result:gsub("[\n\t]+", " ")  -- Cleans up output, replacing newlines and tabs
      if #result <= config.max_fortune_length then
        fortune.last = result
        fortune.last_update_time = current_time
        fortune.ticker_position = 0  -- Reset for new fortune
      end
    end
  end
end

local function get_visible_fortune()
  if not config.enabled then return "" end
  update_fortune(false)
  local length = #fortune.last
  if length == 0 then return "" end

  if length > config.max_length then
    local start_pos = fortune.ticker_position + 1
    local end_pos = start_pos + config.max_length - 1
    return fortune.last:sub(start_pos, end_pos)
  else
    return fortune.last
  end
end

local function update_ticker()
  if config.enabled and #fortune.last > config.max_length then
    fortune.ticker_position = (fortune.ticker_position + 1) % #fortune.last
    vim.api.nvim_command('redrawstatus')
  end
end

-- Command to manually fetch the next fortune
vim.api.nvim_create_user_command('FortuneNext', function()
  update_fortune(true)  -- Force update
  vim.api.nvim_command('redrawstatus')
end, {})

-- Command to toggle the display of fortunes
vim.api.nvim_create_user_command('FortuneToggle', function()
  config.enabled = not config.enabled
  if config.enabled then
    -- When turning on, fetch a new fortune right away
    update_fortune(true)
  else
    -- When turning off, clear current fortune to avoid lingering display
    fortune.last = ""
  end
  vim.api.nvim_command('redrawstatus')
end, {})

-- Set up a timer to update the ticker position
ticker_timer:start(0, config.ticker_update_interval, vim.schedule_wrap(update_ticker))

return get_visible_fortune
