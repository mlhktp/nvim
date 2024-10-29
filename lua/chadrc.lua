-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "catppuccin",

	-- hl_override = {
	-- 	Comment = { italic = true },
	-- 	["@comment"] = { italic = true },
	-- },
}


local function get_cowsay_fortune()
  local handle = io.popen([[ fortune -s -o | cowsay -f "$(printf %s\\n /usr/share/cowsay/cows/*.cow | shuf -n1)" ]])
  local result = handle:read("*a")
  handle:close()
  -- Split the output into lines
  local lines = {}
  for line in result:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  return lines
end

M.nvdash = {
  load_on_startup = true,
  buttons = {
      { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
      { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
      { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
      { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()" },
      { txt = "  Mappings", keys = "ch", cmd = "NvCheatsheet" },

      { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },

      {
        txt = function()
          local stats = require("lazy").stats()
          local ms = math.floor(stats.startuptime) .. " ms"
          return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
        end,
        hl = "NvDashFooter",
        no_gap = true,
      },
      { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
      { txt = [[ __    __   __       __  __   __  __   ______  ______ ]], hl = "NvDashFooter", no_gap = true, rep = false },
      { txt = [[/\ "-./  \ /\ \     /\ \_\ \ /\ \/ /  /\__  _\/\  == \]], hl = "NvDashFooter", no_gap = true, rep = false },
      { txt = [[\ \ \-./\ \\ \ \____\ \  __ \\ \  _"-.\/_/\ \/\ \  _-/]], hl = "NvDashFooter", no_gap = true, rep = false },
      { txt = [[ \ \_\ \ \_\\ \_____\\ \_\ \_\\ \_\ \_\  \ \_\ \ \_\  ]], hl = "NvDashFooter", no_gap = true, rep = false },
      { txt = [[  \/_/  \/_/ \/_____/ \/_/\/_/ \/_/\/_/   \/_/  \/_/  ]], hl = "NvDashFooter", no_gap = true, rep = false },
      { txt = [[                                                      ]], hl = "NvDashFooter", no_gap = true, rep = false },
      { txt = [[       Welcome to @mlhktp's Neovim configuration!     ]], hl = "NvDashFooter", no_gap = true, rep = false },
   },
  header = function()
    local header_lines = {}
    -- Append cowsay fortune lines
    for _, line in ipairs(get_cowsay_fortune()) do
      table.insert(header_lines, line)
    end
    table.insert(header_lines, [[]])
    table.insert(header_lines, [[]])
    table.insert(header_lines, [[]])
    return header_lines
  end,
}

-- Configure the statusline
M.ui = {
  statusline = {
    order = {"mode", "file", "git", "%=", "fortune", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor"},
    modules = {
      fortune = require "fortune.get_visible_fortune",
    },
  },
}
return M
