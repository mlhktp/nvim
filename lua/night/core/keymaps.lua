-- set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" }) -- move to left window
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" }) -- move to bottom window
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" }) -- move to top window
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" }) -- move to right window

-- keymap.set("n", "<ESC><ESC>", "<cmd>nohlsearch<CR>") -- clear search highlights
-- use jk to exit insert mode
keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

-- clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
keymap.set("n", "x", '"_x', { desc = "Delete character without copying" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height

keymap.set("n", "<leader>nt", ":tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<C-q>", ":BufferClose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab

-- zen mode
keymap.set("n", "<leader>zm", ":ZenMode<CR>", { desc = "Toggle Zen Mode" })

keymap.set("n", "<A-1>", ":BufferGoto 1<CR>", { desc = "Go to buffer 1" })
keymap.set("n", "<A-2>", ":BufferGoto 2<CR>", { desc = "Go to buffer 2" })
keymap.set("n", "<A-3>", ":BufferGoto 3<CR>", { desc = "Go to buffer 3" })
keymap.set("n", "<A-4>", ":BufferGoto 4<CR>", { desc = "Go to buffer 4" })
keymap.set("n", "<A-5>", ":BufferGoto 5<CR>", { desc = "Go to buffer 5" })
keymap.set("n", "<A-6>", ":BufferGoto 6<CR>", { desc = "Go to buffer 6" })
keymap.set("n", "<A-7>", ":BufferGoto 7<CR>", { desc = "Go to buffer 7" })
keymap.set("n", "<A-8>", ":BufferGoto 8<CR>", { desc = "Go to buffer 8" })
keymap.set("n", "<A-9>", ":BufferGoto 9<CR>", { desc = "Go to buffer 9" })
keymap.set("n", "<A-0>", ":BufferGoto 0<CR>", { desc = "Go to buffer 0" })

-- FOR NEO TREE
keymap.set("n", "<leader>e", ":Neotree left<CR>", { desc = "Open Neotree left" }) -- toggle file explorer
keymap.set("n", "<leader>ef", ":Neotree float<CR>", { desc = "Open Neotree float" })
keymap.set("n", "<leader>ec", ":Neotree close<CR>", { desc = "Close Neotree" })
keymap.set("n", "<leader>ee", ":Neotree float git_status git_base=main<CR>", { desc = "Git status in Neotree float" })

-- tagbar
keymap.set("n", "<leader>t", ":TagbarToggle<CR>", { desc = "Toggle Tagbar" })

-- terminal
keymap.set("n", "<leader>ot", ":terminal<CR>", { desc = "Open terminal" })

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" }) -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" }) -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Grep string under cursor" }) -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List open buffers" }) -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help tags" }) -- list available help tags

keymap.set("n", "<leader>cc", ":Themery<CR>", { noremap = true, silent = true, desc = "Open Themery" })

keymap.set("n", "<leader>ch", ":lua vim.diagnostic.open_float()<CR>", { desc = "Show diagnostics float" })

----------------------
-- Custom Keymaps
----------------------
keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
keymap.set("n", "<TAB>", ":bn<CR>", { desc = "Next buffer" })
keymap.set("n", "<S-TAB>", ":bp<CR>", { desc = "Previous buffer" })
keymap.set("n", "<C-d>", '<cmd>call smoothie#do("<C-d>zz")<CR>', { desc = "Smooth scroll down" })
keymap.set("n", "<C-u>", '<cmd>call smoothie#do("<C-u>zz")<CR>', { desc = "Smooth scroll up" })
keymap.set("n", "n", "nzz", { desc = "Next search result centered" })
keymap.set("n", "N", "Nzz", { desc = "Previous search result centered" })

keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize window up" })
keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize window down" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Resize window left" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Resize window right" })

-- terminal
keymap.set("t", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Resize terminal up" })
keymap.set("t", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Resize terminal down" })
keymap.set("t", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Resize terminal left" })
keymap.set("t", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Resize terminal right" })

