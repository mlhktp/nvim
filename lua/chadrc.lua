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
    },
  header = function()
    local header_lines = {
      [[ __    __   __       __  __   __  __   ______  ______ ]],
      [[/\ "-./  \ /\ \     /\ \_\ \ /\ \/ /  /\__  _\/\  == \]],
      [[\ \ \-./\ \\ \ \____\ \  __ \\ \  _"-.\/_/\ \/\ \  _-/]],
      [[ \ \_\ \ \_\\ \_____\\ \_\ \_\\ \_\ \_\  \ \_\ \ \_\  ]],
      [[  \/_/  \/_/ \/_____/ \/_/\/_/ \/_/\/_/   \/_/  \/_/  ]],
      [[                                                      ]],
      [[       Welcome to @mlhktp's Neovim configuration!     ]],
      [[                                                      ]]
    }
    -- Append cowsay fortune lines
    for _, line in ipairs(get_cowsay_fortune()) do
      table.insert(header_lines, line)
    end
    table.insert(header_lines, [[                                                      ]])
    return header_lines
  end,
   -- header = {
  --   [[_/\\\\____________/\\\\___/\\\_______________/\\\________/\\\___/\\\________/\\\___/\\\\\\\\\\\\\\\___/\\\\\\\\\\\\\___       ]],
  --   [[_\/\\\\\\________/\\\\\\__\/\\\______________\/\\\_______\/\\\__\/\\\_____/\\\//___\///////\\\/////___\/\\\/////////\\\_      ]],
  --   [[ _\/\\\//\\\____/\\\//\\\__\/\\\______________\/\\\_______\/\\\__\/\\\__/\\\//____________\/\\\________\/\\\_______\/\\\_     ]],
  --   [[  _\/\\\\///\\\/\\\/_\/\\\__\/\\\______________\/\\\\\\\\\\\\\\\__\/\\\\\\//\\\____________\/\\\________\/\\\\\\\\\\\\\/__    ]],
  --   [[   _\/\\\__\///\\\/___\/\\\__\/\\\______________\/\\\/////////\\\__\/\\\//_\//\\\___________\/\\\________\/\\\/////////____   ]],
  --   [[    _\/\\\____\///_____\/\\\__\/\\\______________\/\\\_______\/\\\__\/\\\____\//\\\__________\/\\\________\/\\\_____________  ]],
  --   [[     _\/\\\_____________\/\\\__\/\\\______________\/\\\_______\/\\\__\/\\\_____\//\\\_________\/\\\________\/\\\_____________ ]],
  --   [[      _\/\\\_____________\/\\\__\/\\\\\\\\\\\\\\\__\/\\\_______\/\\\__\/\\\______\//\\\________\/\\\________\/\\\____________ ]],
  --   [[       _\///______________\///___\///////////////___\///________\///___\///________\///_________\///_________\///____________ ]],
  --   [[                                                                                                                              ]],
  --   [[                                            Welcome to @mlhktp's Neovim configuration!]]
  -- },
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
 -- M.ui = {
 --   statusline = {
 --     theme = "default", 
 --     separator_style = "default",
 --     order = { "mode", "f", "git", "%=", "lsp_msg", "%=", "lsp", "cwd", "xyz", "abc" },
 --     modules = {
 --       abc = function()
 --         return "hi"
 --       end,
 --
 --       xyz =  "hi",
 --       f = "%F"
 --     }
 --   },
 -- }
return M
