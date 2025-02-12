require("night.core")
require("night.lazy")

vim.api.nvim_set_option("clipboard", "unnamedplus")
vim.cmd("colorscheme kanagawa")

-- let g:vimtex_view_method = 'zathura'
vim.g.vimtex_view_method = "zathura"

-- everforest
-- tokyonight-night tokyonight-storm tokyonight-day tokyonight-moon
-- wal
-- yorumi
-- neofusion
-- rose-pine rose-pine-main rose-pine-moon rose-pine-dawn
-- nightfly
-- tokyonight-night, tokyonight-storm, tokyonight-day, tokyonight-moon,
-- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
-- kanagawa-wave, kanagawa-dragon, kanagawa-lotus
-- gruvbox
-- moonfly
-- onenord, onenord-light
-- ayu, ayu-dark, ayu-light, ayu-mirage
-- solarized-osaka, solarized-osaka-day, solarized-osaka-moon, solarized-osaka-storm, solarized-osaka-night

local on_attach = function(client, bufnr)
	require("nlspsettings").update_settings(client.name)
end

local nvim_lsp = require("lspconfig")
local nlspsettings = require("nlspsettings")

nvim_lsp.svlangserver.setup({
	on_attach = on_attach,
})
nlspsettings.setup({})


if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
   --
   vim.o.guifont = "FiraCode Nerd Font:h8.5:x8.0" -- text below applies for VimScript
   vim.g.neovide_padding_top = 20
   vim.g.neovide_padding_bottom = 30
   vim.g.neovide_padding_right = 20
   vim.g.neovide_padding_left = 20
   -- font line size 140%
end

