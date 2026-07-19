local map = vim.keymap.set
local terminal_opts = { silent = true }

map("n", "<leader>ot", "<cmd>terminal<CR>", { desc = "Open terminal" })
map({ "n", "t" }, "<M-i>", "<cmd>ToggleTerm direction=float name=termFloat<CR>", {
   desc = "Toggle floating terminal",
})

map("t", "<Esc>", [[<C-\><C-n>]], terminal_opts)
map("t", "jk", [[<C-\><C-n>]], terminal_opts)
map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], terminal_opts)
map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], terminal_opts)
map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], terminal_opts)
map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], terminal_opts)
map("t", "<C-w>", [[<C-\><C-n><C-w>]], terminal_opts)
map("t", "<C-Up>", "<cmd>resize -2<CR>", terminal_opts)
map("t", "<C-Down>", "<cmd>resize +2<CR>", terminal_opts)
map("t", "<C-Left>", "<cmd>vertical resize -2<CR>", terminal_opts)
map("t", "<C-Right>", "<cmd>vertical resize +2<CR>", terminal_opts)
