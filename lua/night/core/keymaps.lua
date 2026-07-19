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

-- keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR>") -- clear search highlights
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
-- keymap.set("n", "<leader>cs", ":close<CR>") -- close current split window

keymap.set("n", "<leader>nt", ":tabnew<CR>") -- open new tab
keymap.set("n", "<C-q>", ":BufferClose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- LSP Keybinds
----------------------
keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "LSP: Show references" })
keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })
keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP: Show definitions" })
keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP: Show implementations" })
keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "LSP: Show type definitions" })
keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: See available code actions" })
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Smart rename" })
keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "LSP: Show diagnostics for file" })
keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "LSP: Show diagnostics in float" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Go to previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Go to next diagnostic" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })
keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "LSP: Restart LSP server" })
keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP: Format buffer" })
keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: Add workspace folder" })
keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP: Remove workspace folder" })
keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "LSP: List workspace folders" })
keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature help" })
keymap.set("n", '<space>q', vim.diagnostic.setloclist, { desc = "LSP: Diagnostics to location list" })

-- zen mode
keymap.set("n", "<leader>zm", ":ZenMode<CR>")

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

-- Conflict resolver
keymap.set("n", "<leader>gdo", "<cmd>Neotree close | Gvdiffsplit! | wincmd J | resize 20<CR>", { desc = "Open diff view for conflicted file" })
keymap.set("n", "<leader>gdc", "<cmd>Gvdiffclose<CR>", { desc = "Close diff view for conflicted file" })
keymap.set("n", "<leader>gdh", "<cmd>diffget //2<CR>", { desc = "Accept local changes" })
keymap.set("n", "<leader>gdl", "<cmd>diffget //3<CR>", { desc = "Accept remote changes" })

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory


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
keymap.set("n", "<C-d>", '<cmd>call smoothie#do("<C-d>zz")<CR>')
keymap.set("n", "<C-u>", '<cmd>call smoothie#do("<C-u>zz")<CR>')
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

keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

-- META KEYS
keymap.set({"n","t"}, "<M-i>", "<cmd>ToggleTerm direction=float name=termFloat<CR>")
-- keymap.set({"n","t"}, "<M-->", "<cmd>ToggleTerm direction=horizontal name=termHorizontal<CR>")
-- keymap.set({"n","t"}, "<M-v>", "<cmd>ToggleTerm direction=vertical size=70 name=termVertical<CR>")
keymap.set("n", "<C-1>", ":BufferGoto 1<CR>")
keymap.set("n", "<C-2>", ":BufferGoto 2<CR>")
keymap.set("n", "<C-3>", ":BufferGoto 3<CR>")
keymap.set("n", "<C-4>", ":BufferGoto 4<CR>")
keymap.set("n", "<C-5>", ":BufferGoto 5<CR>")
keymap.set("n", "<C-6>", ":BufferGoto 6<CR>")
keymap.set("n", "<C-7>", ":BufferGoto 7<CR>")
keymap.set("n", "<C-8>", ":BufferGoto 8<CR>")
keymap.set("n", "<C-9>", ":BufferGoto 9<CR>")
keymap.set("n", "<C-0>", ":BufferGoto 0<CR>")

-- keymap.set("n", "<M-h>", "g^") -- move to beginning of line
-- keymap.set("n", "<M-l>", "g$") -- move to end of line
-- keymap.set("v", "<M-h>", "^") -- move to beginning of line
-- keymap.set("v", "<M-l>", "$") -- move to end of line


keymap.set("n", "<C-p>", "<Plug>ReplaceWithRegisterOperatoriw", { noremap = false })
keymap.set("n", "<C-[>", "<Plug>ReplaceWithRegisterOperator")
keymap.set("v", "<C-p>", "<Plug>ReplaceWithRegisterVisual")


keymap.set("n", "<M-e>", "<cmd>Neotree left toggle<CR>") -- toggle file explorer
keymap.set("n", "<M-S-e>", "<cmd>Neotree float toggle<CR>") -- toggle file explorer
keymap.set("n", "<M-r>", "<cmd>Neotree verilog_hierarchy left toggle<CR>", { desc = "Toggle Verilog hierarchy in Neo-tree" })
keymap.set("n", "<M-S-r>", "<cmd>Neotree verilog_hierarchy float toggle<CR>", { desc = "Toggle Flot Verilog hierarchy in Neo-tree" })

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

keymap.set("n", "<C-h>", "<C-w>h") -- move to left window
keymap.set("n", "<C-j>", "<C-w>j") -- move to bottom window
keymap.set("n", "<C-k>", "<C-w>k") -- move to top window
keymap.set("n", "<C-l>", "<C-w>l") -- move to right window

-- keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR>") -- clear search highlights
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
-- keymap.set("n", "<leader>cs", ":close<CR>") -- close current split window

keymap.set("n", "<leader>nt", ":tabnew<CR>") -- open new tab
keymap.set("n", "<C-q>", ":BufferClose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --  go to previous tab

----------------------
-- LSP Keybinds
----------------------
keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", { desc = "LSP: Show references" })
keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })
keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP: Show definitions" })
keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP: Show implementations" })
keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", { desc = "LSP: Show type definitions" })
keymap.set({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, { desc = "LSP: See available code actions" })
keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Smart rename" })
keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", { desc = "LSP: Show diagnostics for file" })
keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "LSP: Show diagnostics in float" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "LSP: Go to previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "LSP: Go to next diagnostic" })
keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover documentation" })
keymap.set("n", "<leader>rs", ":LspRestart<CR>", { desc = "LSP: Restart LSP server" })
keymap.set("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP: Format buffer" })
keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "LSP: Add workspace folder" })
keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "LSP: Remove workspace folder" })
keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { desc = "LSP: List workspace folders" })
keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature help" })
keymap.set("n", '<space>q', vim.diagnostic.setloclist, { desc = "LSP: Diagnostics to location list" })

-- zen mode
keymap.set("n", "<leader>zm", ":ZenMode<CR>")

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

-- Conflict resolver
keymap.set("n", "<leader>gdo", "<cmd>Neotree close | Gvdiffsplit! | wincmd J | resize 20<CR>", { desc = "Open diff view for conflicted file" })
keymap.set("n", "<leader>gdc", "<cmd>Gvdiffclose<CR>", { desc = "Close diff view for conflicted file" })
keymap.set("n", "<leader>gdh", "<cmd>diffget //2<CR>", { desc = "Accept local changes" })
keymap.set("n", "<leader>gdl", "<cmd>diffget //3<CR>", { desc = "Accept remote changes" })

-- restart lsp server
keymap.set("n", "<leader>rs", ":LspRestart<CR>") -- mapping to restart lsp if necessary

keymap.set("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
keymap.set("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory


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
keymap.set("n", "<C-d>", '<cmd>call smoothie#do("<C-d>zz")<CR>')
keymap.set("n", "<C-u>", '<cmd>call smoothie#do("<C-u>zz")<CR>')
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

keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

-- META KEYS
keymap.set({"n","t"}, "<M-i>", "<cmd>ToggleTerm direction=float name=termFloat<CR>")
-- keymap.set({"n","t"}, "<M-->", "<cmd>ToggleTerm direction=horizontal name=termHorizontal<CR>")
-- keymap.set({"n","t"}, "<M-v>", "<cmd>ToggleTerm direction=vertical size=70 name=termVertical<CR>")
keymap.set("n", "<C-1>", ":BufferGoto 1<CR>")
keymap.set("n", "<C-2>", ":BufferGoto 2<CR>")
keymap.set("n", "<C-3>", ":BufferGoto 3<CR>")
keymap.set("n", "<C-4>", ":BufferGoto 4<CR>")
keymap.set("n", "<C-5>", ":BufferGoto 5<CR>")
keymap.set("n", "<C-6>", ":BufferGoto 6<CR>")
keymap.set("n", "<C-7>", ":BufferGoto 7<CR>")
keymap.set("n", "<C-8>", ":BufferGoto 8<CR>")
keymap.set("n", "<C-9>", ":BufferGoto 9<CR>")
keymap.set("n", "<C-0>", ":BufferGoto 0<CR>")

-- keymap.set("n", "<M-h>", "g^") -- move to beginning of line
-- keymap.set("n", "<M-l>", "g$") -- move to end of line
-- keymap.set("v", "<M-h>", "^") -- move to beginning of line
-- keymap.set("v", "<M-l>", "$") -- move to end of line


keymap.set("n", "<C-p>", "<Plug>ReplaceWithRegisterOperatoriw", { noremap = false })
keymap.set("n", "<C-[>", "<Plug>ReplaceWithRegisterOperator")
keymap.set("v", "<C-p>", "<Plug>ReplaceWithRegisterVisual")


keymap.set("n", "<M-e>", "<cmd>Neotree left toggle<CR>") -- toggle file explorer
keymap.set("n", "<M-S-e>", "<cmd>Neotree float toggle<CR>") -- toggle file explorer
keymap.set("n", "<M-r>", "<cmd>Neotree verilog_hierarchy left toggle<CR>", { desc = "Toggle Verilog hierarchy in Neo-tree" })
keymap.set("n", "<M-S-r>", "<cmd>Neotree verilog_hierarchy float toggle<CR>", { desc = "Toggle Flot Verilog hierarchy in Neo-tree" })
