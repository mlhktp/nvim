-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

keymap.set("n", "<C-h>", "<C-w>h") -- move to left window
keymap.set("n", "<C-j>", "<C-w>j") -- move to bottom window
keymap.set("n", "<C-k>", "<C-w>k") -- move to top window
keymap.set("n", "<C-l>", "<C-w>l") -- move to right window

-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>")

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- delete single character without copying into register
keymap.set("n", "x", '"_x')

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>") -- increment
keymap.set("n", "<leader>-", "<C-x>") -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v") -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split window horizontally

keymap.set("n", "<leader>se", "<C-w>=") -- make split windows equal width & height
keymap.set("n", "<leader>cs", ":close<CR>") -- close current split window

keymap.set("n", "<leader>nt", ":tabnew<CR>") -- open new tab
keymap.set("n", "<C-q>", ":BufferClose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------
keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file
keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

-- zen mode
keymap.set("n", "<leader>zm", ":ZenMode<CR>")

keymap.set("n", "<A-1>", ":BufferGoto 1<CR>")
keymap.set("n", "<A-2>", ":BufferGoto 2<CR>")
keymap.set("n", "<A-3>", ":BufferGoto 3<CR>")
keymap.set("n", "<A-4>", ":BufferGoto 4<CR>")
keymap.set("n", "<A-5>", ":BufferGoto 5<CR>")
keymap.set("n", "<A-6>", ":BufferGoto 6<CR>")
keymap.set("n", "<A-7>", ":BufferGoto 7<CR>")
keymap.set("n", "<A-8>", ":BufferGoto 8<CR>")
keymap.set("n", "<A-9>", ":BufferGoto 9<CR>")
keymap.set("n", "<A-0>", ":BufferGoto 0<CR>")
keymap.set("n", "<A-j>", ":BufferNext<CR>")
keymap.set("n", "<A-k>", ":BufferPrevious<CR>")
-- vim-maximizer
keymap.set("n", "<leader>mt", ":MaximizerToggle<CR>") -- toggle split window maximization

-- FOR NEO TREE
keymap.set("n", "<leader>e", ":Neotree left<CR>") -- toggle file explorer
keymap.set("n", "<leader>ef", ":Neotree float<CR>")
keymap.set("n", "<leader>ec", ":Neotree close<CR>")
keymap.set("n", "<leader>ee", ":Neotree float git_status git_base=main<CR>")

-- tagbar
keymap.set("n", "<leader>t", ":TagbarToggle<CR>")

-- terminal
keymap.set("n", "<leader>ot", ":terminal<CR>")

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

-- telescope git commandsmap
keymap.set("n", "<leader>gp", "<cmd> Gitsigns preview_hunk <cr>", { desc = "Gitsigns Preview Hunk" })
keymap.set("n", "<leader>gi", "<cmd> Gitsigns preview_hunk_inline <cr>", { desc = "Gitsigns Preview Hunk Inline" })
keymap.set("n", "<leader>gs", "<cmd> Gitsigns stage_hunk <cr>", { desc = "Gitsigns Stage Hunk" })
keymap.set("n", "<leader>gS", "<cmd> Gitsigns stage_buffer <cr>", { desc = "Gitsigns Stage Buffer" })
keymap.set("n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>zz", { desc = "Gitsigns Next Hunk" })
keymap.set("n", "<leader>gN", "<cmd> Gitsigns prev_hunk <cr>", { desc = "Gitsigns Previous Hunk" })
keymap.set("n", "<leader>gr", "<cmd> Gitsigns reset_hunk <cr>", { desc = "Gitsigns Reset Hunk" })
keymap.set("n", "<leader>gR", "<cmd> Gitsigns reset_buffer <cr>", { desc = "Gitsigns Reset Buffer" })
keymap.set("n", "<leader>gu", "<cmd> Gitsigns undo_stage_hunk <cr>", { desc = "Gitsigns Undo Stage Hunk" })
keymap.set("n", "<leader>gU", "<cmd> Gitsigns reset_buffer_index <cr>", { desc = "Gitsigns Reset Buffer Index" })

keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Telescope Git Commits" }) -- list all git commits (use <cr> to checkout) ["gc" for git commits]
keymap.set("n", "<leader>gbc", "<cmd>Telescope git_bcommits<cr>", { desc = "Telescope Buffer Commits" }) -- list git commits for current file/buffer (use <cr> to checkout) ["gfc" for git file commits]
keymap.set("n", "<leader>gbr", "<cmd>Telescope git_branches<cr>", { desc = "Telescope Git Branches" }) -- list git branches (use <cr> to checkout) ["gb" for git branch]
keymap.set("n", "<leader>gst", "<cmd>Telescope git_status<cr>", { desc = "Telescope Git Status" }) -- list current changes per file with diff preview ["gs" for git status]

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory

-- local harpoon = require("plugins.harpoon")
-- -- -- required
-- -- harpoon:setup()
-- -- -- required
-- keymap.set("n", "<leader>hm", function()
-- 	harpoon:list():add()
-- end, { desc = "mark file with harpoon" })
-- keymap.set("n", "<leader>hp", function()
-- 	harpoon:list():prev()
-- end, { desc = "go to next harpoon mark" })
-- keymap.set("n", "<leader>hn", function()
-- 	harpoon:list():next()
-- end, { desc = "go to previous harpoon mark" })
-- keymap.set("n", "<leader>hm", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Mark file with harpoon" })
-- keymap.set("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<cr>", { desc = "Go to previous harpoon mark" })
-- keymap.set("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<cr>", { desc = "Go to next harpoon mark" })

keymap.set("n", "<leader>cc", ":Themery<CR>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<C-t>", function()
-- 	require("menu").open("default")
-- end, {})

keymap.set("n", "<leader>ch", ":lua vim.diagnostic.open_float()<CR>", { desc = "Diagnostic" })

----------------------
-- Custom Keymaps
----------------------
keymap.set("v", ">", ">gv")
keymap.set("v", "<", "<gv")
keymap.set("n", "<TAB>", ":bn<CR>")
keymap.set("n", "<S-TAB>", ":bp<CR>")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzz")
keymap.set("n", "N", "Nzz")

keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

keymap.set("n", "<C-Up>", ":resize -2<CR>")
keymap.set("n", "<C-Down>", ":resize +2<CR>")
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- terminal
keymap.set("t", "<C-Up>", "<cmd>resize -2<CR>")
keymap.set("t", "<C-Down>", "<cmd>resize +2<CR>")
keymap.set("t", "<C-Left>", "<cmd>vertical resize -2<CR>")
keymap.set("t", "<C-Right>", "<cmd>vertical resize +2<CR>")

keymap.set("t", "<C-h>", "<cmd>wincmd h<CR>")
keymap.set("t", "<C-j>", "<cmd>wincmd j<CR>")
keymap.set("t", "<C-k>", "<cmd>wincmd k<CR>")
keymap.set("t", "<C-l>", "<cmd>wincmd l<CR>")
