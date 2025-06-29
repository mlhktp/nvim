-- Extra commands for the Verilog hierarchy source

local cc      = require("neo-tree.sources.common.commands")
local manager = require("neo-tree.sources.manager")

local function goto_loc(loc)
  if not (loc and loc.file) then
    return false
  end

  vim.cmd("wincmd p") -- e.g., switch to previous window if Neo-tree steals focus

  -- open the file
  vim.cmd("edit " .. vim.fn.fnameescape(loc.file))

  -- nvim API uses 1-based line, 0-based column
  local row = (loc.start_line or 0)
  local col = 0  -- just start at the beginning of the line

  -- clamp line number to buffer line count
  local buf = vim.api.nvim_get_current_buf()
  local last = vim.api.nvim_buf_line_count(buf)
  if row > last then row = last end

  vim.api.nvim_win_set_cursor(0, { row, col })

  return true
end

local M = {}

-- jump to module declaration
M.open_module = function(state)
  local node = state.tree:get_node()
  local locs = require("verilog_hierarchy").loc_map[node:get_id()]
  if not goto_loc(locs and locs.mod_loc) then
    vim.notify("Verilog-hierarchy: no module location available", vim.log.levels.WARN)
  end
end

-- jump to instantiation site
M.open_instance = function(state)
  local node = state.tree:get_node()
  local locs = require("verilog_hierarchy").loc_map[node:get_id()]
  if not goto_loc(locs and locs.inst_loc) then
    vim.notify("Verilog-hierarchy: no instance location available", vim.log.levels.WARN)
  end
end

-------------------------------------------------------------------------------
-- Convenience stuff ----------------------------------------------------------
-------------------------------------------------------------------------------
M.print_name = function(state)
  local node = state.tree:get_node()
  print("Node: "..node.name)
end

M.refresh = function(state)
  manager.refresh("verilog_hierarchy", state)
end

cc._add_common_commands(M)
return M
