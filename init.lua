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
