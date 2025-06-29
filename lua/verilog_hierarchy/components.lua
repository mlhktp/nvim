-- lua/verilog_hierarchy/components.lua
-- Custom icon / size / mtime renderers that stat the file directly

local highlights = require("neo-tree.ui.highlights")
local common     = require("neo-tree.sources.common.components")
local uv         = vim.loop
local utils = require("neo-tree.utils")

local M = {}

-------------------------------------------------------------------------------
-- 1) Icon (folder vs file) ---------------------------------------------------
-------------------------------------------------------------------------------
-- choose whichever set you like best:
local CLOSED_ICON = "▶"   -- triangle ▶
local OPEN_ICON   = "▼"   -- triangle ▼
local FILE_ICON   = " "  -- file glyph

M.icon = function(_, node, _)
  local glyph = node.type == "directory"
    and ((node:is_expanded() and OPEN_ICON) or CLOSED_ICON)
    or FILE_ICON
  local hl = node.type == "directory"
             and highlights.DIRECTORY_ICON
             or highlights.FILE_ICON
  return { text = glyph .. " ", highlight = hl }
end

local truncate_string = function(str, max_length)
  if #str <= max_length then
    return str
  end
  return str:sub(1, max_length - 1) .. "…"
end

local get_header = function(state, label, size)
  if state.sort and state.sort.label == label then
    local icon = state.sort.direction == 1 and "▲" or "▼"
    size = size - 2
    ---diagnostic here is wrong, printf has arbitrary args.
    ---@diagnostic disable-next-line: redundant-parameter
    return vim.fn.printf("%" .. size .. "s %s  ", truncate_string(label, size), icon)
  end
  return vim.fn.printf("%" .. size .. "s  ", truncate_string(label, size))
end

M.file_size = function(config, node, state)
  -- Root node gets column labels
  if node:get_depth() == 1 then
    return {
      text = get_header(state, "Size", config.width),
      highlight = highlights.FILE_STATS_HEADER,
    }
  end

  local text = "-"
  local stat = utils.get_stat(node)
  local size = stat and stat.size or nil
  if size then
    local success, human = pcall(utils.human_size, size)
    if success then
      text = human or text
    end
  end

  return {
    text = vim.fn.printf("%" .. config.width .. "s  ", truncate_string(text, config.width)),
    highlight = config.highlight or highlights.FILE_STATS,
  }
end

M.type = function(config, node, state)
  -- roots get the header label
  if node:get_depth() == 1 then
    return {
      text = get_header(state, "Type", config.width),
      highlight = highlights.FILE_STATS_HEADER,
    }
  end

  -- extract extension, lower-case
  local ext = ""
  if node.path then
    ext = node.path:match("%.([^.]+)$") or ""
    ext = ext:lower()
  end

  -- map to human names
  local m = {
    sv  = "systemverilog",
    v   = "verilog",
    vh  = "verilog",
    vhd = "vhdl",
    svh = "systemverilog",
  }
  local typ = m[ext] or (ext ~= "" and ext) or ""

  return {
    text = vim.fn.printf("%" .. config.width .. "s  ", truncate_string(typ, config.width)),
    highlight = highlights.FILE_STATS,
  }
end

M.name = function(config, node, state)
  local highlight = config.highlight or highlights.FILE_NAME
  local text = node.name
  if node.type == "directory" then
    highlight = highlights.FILE_NAME
    if config.trailing_slash and text ~= "/" then
      text = text .. "/"
    end
  end

  if node:get_depth() == 1 and node.type ~= "message" then
    highlight = highlights.ROOT_NAME
    if state.current_position == "current" and state.sort and state.sort.label == "Name" then
      local icon = state.sort.direction == 1 and "▲" or "▼"
      text = text .. "  " .. icon
    end
  else
    local filtered_by = common.filtered_by(config, node, state)
    highlight = filtered_by.highlight or highlight
    if config.use_git_status_colors then
      local git_status = state.components.git_status({}, node, state)
      if git_status and git_status.highlight then
        highlight = git_status.highlight
      end
    end
  end

  local hl_opened = config.highlight_opened_files
  if hl_opened then
    local opened_buffers = state.opened_buffers or {}
    if
      (hl_opened == "all" and opened_buffers[node.path])
      or (opened_buffers[node.path] and opened_buffers[node.path].loaded)
    then
      highlight = highlights.FILE_NAME_OPENED
    end
  end

  if type(config.right_padding) == "number" then
    if config.right_padding > 0 then
      text = text .. string.rep(" ", config.right_padding)
    end
  else
    text = text
  end

  return {
    text = text,
    highlight = highlight,
  }
end
return vim.tbl_deep_extend("force", common, M)
