local map = vim.keymap.set

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "x", '"_x', { desc = "Delete character without yanking" })
map("n", "<leader>+", "<C-a>", { desc = "Increment number" })
map("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize window sizes" })

map("n", "<leader>nt", "<cmd>tabnew<CR>", { desc = "New tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<C-q>", "<cmd>BufferClose<CR>", { desc = "Close buffer" })
map("n", "<Tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

for index = 1, 9 do
   map("n", "<C-" .. index .. ">", "<cmd>BufferGoto " .. index .. "<CR>", { desc = "Go to buffer " .. index })
end
map("n", "<C-0>", "<cmd>BufferGoto 0<CR>", { desc = "Go to last buffer" })

map("v", ">", ">gv", { desc = "Indent selection" })
map("v", "<", "<gv", { desc = "Unindent selection" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "<C-d>", '<cmd>call smoothie#do("<C-d>zz")<CR>', { desc = "Scroll down" })
map("n", "<C-u>", '<cmd>call smoothie#do("<C-u>zz")<CR>', { desc = "Scroll up" })
map("n", "n", "nzz", { desc = "Next search result" })
map("n", "N", "Nzz", { desc = "Previous search result" })

map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

map("n", "<C-p>", "<Plug>ReplaceWithRegisterOperatoriw", { remap = true })
map("n", "<C-[>", "<Plug>ReplaceWithRegisterOperator")
map("v", "<C-p>", "<Plug>ReplaceWithRegisterVisual")
