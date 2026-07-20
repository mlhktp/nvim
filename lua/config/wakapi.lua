local M = {}

local weeks = 13
local cell = "■   "
local cell_width = 4
local day = 24 * 60 * 60
local cache_file = vim.fs.joinpath(vim.fn.stdpath("cache"), "wakapi-dashboard.json")

local function trim(value)
   return value:match("^%s*(.-)%s*$")
end

local function read_wakatime_config()
   local path = vim.fn.expand("~/.wakatime.cfg")
   local ok, lines = pcall(vim.fn.readfile, path)
   if not ok then
      return {}
   end

   local result = {}
   local section
   for _, line in ipairs(lines) do
      local next_section = line:match("^%s*%[([^%]]+)%]%s*$")
      if next_section then
         section = next_section
      elseif section == "settings" then
         local key, value = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
         if key and value and not value:match("^[#;]") then
            result[key] = trim(value):gsub('^(["\'])(.*)%1$', "%2")
         end
      end
   end
   return result
end

local function credentials()
   local config = read_wakatime_config()
   local url = config.api_url
   local api_key = config.api_key

   if not url or url == "" or not api_key or api_key == "" then
      return nil
   end

   url = url:gsub("/+$", "")
   if url:match("/api/compat/wakatime/v1$") then
      -- Already a Wakapi compatibility API URL.
   elseif url:match("/api$") then
      url = url:gsub("/api$", "/api/compat/wakatime/v1")
   else
      url = url .. "/api/compat/wakatime/v1"
   end

   return { url = url, api_key = api_key }
end

local function noon(timestamp)
   local parts = os.date("*t", timestamp or os.time())
   parts.hour, parts.min, parts.sec = 12, 0, 0
   return os.time(parts)
end

local function date_at(timestamp)
   return os.date("%Y-%m-%d", timestamp)
end

local function calendar_range(weeks)
   local today = noon()
   local weekday = tonumber(os.date("%w", today))
   local days_since_monday = (weekday + 6) % 7
   local first_day = today - ((weeks - 1) * 7 + days_since_monday) * day
   return first_day, today
end

local function escape_curl_config(value)
   return value:gsub("\\", "\\\\"):gsub('"', '\\"')
end

local function decode(payload)
   local ok, value = pcall(vim.json.decode, payload)
   if not ok or type(value) ~= "table" then
      return nil
   end
   return value
end

function M.read_cache()
   local ok, lines = pcall(vim.fn.readfile, cache_file)
   if not ok then
      return nil
   end
   local cached = decode(table.concat(lines, "\n"))
   return cached and cached.payload or nil
end

local function write_cache(payload)
   vim.fn.mkdir(vim.fs.dirname(cache_file), "p")
   pcall(vim.fn.writefile, { vim.json.encode({ fetched_at = os.time(), payload = payload }) }, cache_file)
end

function M.fetch(callback)
   local auth = credentials()
   if not auth then
      callback(nil, "Add api_url and api_key to ~/.wakatime.cfg")
      return
   end
   if vim.fn.executable("curl") ~= 1 then
      callback(nil, "curl is required to load Wakapi")
      return
   end

   local first_day, today = calendar_range(weeks)
   local endpoint = string.format(
      "%s/users/current/summaries?start=%s&end=%s",
      auth.url,
      date_at(first_day),
      date_at(today)
   )
   local authorization = "Authorization: Basic " .. vim.base64.encode(auth.api_key)
   local curl_config = 'header = "' .. escape_curl_config(authorization) .. '"\n'

   vim.system(
      { "curl", "--fail", "--silent", "--show-error", "--max-time", "6", "--config", "-", endpoint },
      { text = true, stdin = curl_config },
      vim.schedule_wrap(function(result)
         if result.code ~= 0 then
            callback(nil, "Wakapi is unavailable")
            return
         end
         local payload = decode(result.stdout)
         if not payload or type(payload.data) ~= "table" then
            callback(nil, "Wakapi returned an unexpected response")
            return
         end
         write_cache(payload)
         callback(payload)
      end)
   )
end

local function seconds_for(entry)
   local total = entry.grand_total or entry.total or {}
   return tonumber(total.total_seconds or total.seconds) or 0
end

local function entry_date(entry)
   local range = entry.range or {}
   return (range.start and range.start:sub(1, 10)) or (range.date and range.date:sub(1, 10))
end

local function format_duration(seconds)
   local minutes = math.floor(seconds / 60)
   if seconds == 0 then
      return "0m"
   end
   if minutes < 1 then
      return "<1m"
   end
   local hours = math.floor(minutes / 60)
   minutes = minutes % 60
   if hours == 0 then
      return string.format("%dm", minutes)
   elseif minutes == 0 then
      return string.format("%dh", hours)
   end
   return string.format("%dh %02dm", hours, minutes)
end

local function activity_by_date(payload)
   local activity = {}
   for _, entry in ipairs(payload and payload.data or {}) do
      local date = entry_date(entry)
      if date then
         activity[date] = seconds_for(entry)
      end
   end
   return activity
end

local function streaks(activity, first_day, today)
   local current, longest, running = 0, 0, 0
   local timestamp = first_day
   while timestamp <= today do
      if (activity[date_at(timestamp)] or 0) > 0 then
         running = running + 1
         longest = math.max(longest, running)
      else
         running = 0
      end
      timestamp = timestamp + day
   end

   timestamp = today
   if (activity[date_at(timestamp)] or 0) == 0 then
      timestamp = timestamp - day
   end
   while timestamp >= first_day and (activity[date_at(timestamp)] or 0) > 0 do
      current = current + 1
      timestamp = timestamp - day
   end
   return current, longest
end

local function summary(payload, activity, first_day, today)
   local current, longest = streaks(activity, first_day, today)
   local total = 0
   for offset = 0, 6 do
      total = total + (activity[date_at(today - offset * day)] or 0)
   end
   local function days(value)
      return value == 1 and "day" or "days"
   end
   return string.format(
      "%s this week   ·   %d %s streak   ·   %d %s best",
      format_duration(total),
      current,
      days(current),
      longest,
      days(longest)
   )
end

local function month_line(first_day, weeks)
   local width = 3 + weeks * cell_width
   local chars = {}
   for i = 1, width do
      chars[i] = " "
   end

   local previous_month
   for column = 0, weeks - 1 do
      local timestamp = first_day + column * 7 * day
      local month = os.date("%b", timestamp):upper()
      if month ~= previous_month then
         local start = 4 + column * cell_width
         for i = 1, #month do
            if start + i - 1 <= width then
               chars[start + i - 1] = month:sub(i, i)
            end
         end
         previous_month = month
      end
   end
   return table.concat(chars):gsub("%s+$", "")
end

local function activity_level(seconds, active_seconds)
   if seconds <= 0 then
      return 0
   end
   for level = 1, 3 do
      local index = math.max(1, math.ceil(#active_seconds * level / 4))
      if seconds <= active_seconds[index] then
         return level
      end
   end
   return 4
end

function M.view(payload)
   local first_day, today = calendar_range(weeks)
   local activity = activity_by_date(payload)
   local active_seconds = {}
   for _, seconds in pairs(activity) do
      if seconds > 0 then
         table.insert(active_seconds, seconds)
      end
   end
   table.sort(active_seconds)

   local last_day = first_day + weeks * 7 * day - day
   local labels = { "M", " ", "W", " ", "F", " ", "S" }
   local lines = {
      "ACTIVITY",
      string.format("%s  —  %s", os.date("%d %b", first_day), os.date("%d %b", last_day)),
      "",
      (month_line(first_day, weeks)),
   }
   local highlights = {
      { { "AlphaZenActivity", 0, -1 } },
      { { "AlphaZenMuted", 0, -1 } },
      {},
      { { "AlphaZenMuted", 0, -1 } },
   }

   for row = 0, 6 do
      local line = labels[row + 1] .. "  "
      local line_highlights = { { "AlphaZenMuted", 0, 1 } }
      for column = 0, weeks - 1 do
         local timestamp = first_day + (column * 7 + row) * day
         local start_byte = #line
         if timestamp > today then
            line = line .. string.rep(" ", cell_width)
         else
            local seconds = activity[date_at(timestamp)] or 0
            local level = activity_level(seconds, active_seconds)
            line = line .. cell
            table.insert(line_highlights, { "AlphaWakapi" .. level, start_byte, start_byte + #cell - 1 })
         end
      end
      table.insert(lines, (line:gsub("%s+$", "")))
      table.insert(highlights, line_highlights)
      -- add empty lines in between
      -- table.insert(lines, "")
      -- table.insert(highlights, {})
   end

   return {
      lines = lines,
      highlights = highlights,
      summary = summary(payload, activity, first_day, today),
   }
end

return M
