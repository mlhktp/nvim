local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "night.plugins" },
	{ import = "night.plugins.lsp" },
	{ import = "night.plugins.ui" },
	{ import = "night.plugins.git" },
}, {
	install = {
		colorscheme = { "tokyonight-storm" },
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = true,
	},
	ui = {
		border = "double",
		size = {
			width = 0.8,
			height = 0.8,
		},
	},
})
local keymap = vim.keymap -- for conciseness
local harpoon = require("harpoon")
-- -- required
harpoon:setup()
-- -- required
keymap.set("n", "<leader>hm", function()
	harpoon:list():add()
end, { desc = "mark file with harpoon" })
keymap.set("n", "<leader>hp", function()
	harpoon:list():prev()
end, { desc = "go to next harpoon mark" })
keymap.set("n", "<leader>hn", function()
	harpoon:list():next()
end, { desc = "go to previous harpoon mark" })
