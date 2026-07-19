local map = vim.keymap.set

map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Git: Preview hunk" })
map("n", "<leader>gi", "<cmd>Gitsigns preview_hunk_inline<CR>", { desc = "Git: Preview hunk inline" })
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>", { desc = "Git: Stage hunk" })
map("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<CR>", { desc = "Git: Stage buffer" })
map("n", "<leader>gn", "<cmd>Gitsigns next_hunk<CR>zz", { desc = "Git: Next hunk" })
map("n", "<leader>gN", "<cmd>Gitsigns prev_hunk<CR>", { desc = "Git: Previous hunk" })
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>", { desc = "Git: Reset hunk" })
map("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<CR>", { desc = "Git: Reset buffer" })
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<CR>", { desc = "Git: Undo staged hunk" })
map("n", "<leader>gU", "<cmd>Gitsigns reset_buffer_index<CR>", { desc = "Git: Reset buffer index" })

map("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git: Commits" })
map("n", "<leader>gbc", "<cmd>Telescope git_bcommits<CR>", { desc = "Git: Buffer commits" })
map("n", "<leader>gbr", "<cmd>Telescope git_branches<CR>", { desc = "Git: Branches" })
map("n", "<leader>gst", "<cmd>Telescope git_status<CR>", { desc = "Git: Status" })

map("n", "<leader>gdo", "<cmd>Neotree close | Gvdiffsplit! | wincmd J | resize 20<CR>", {
   desc = "Git: Open conflict diff",
})
map("n", "<leader>gdc", "<cmd>Gvdiffclose<CR>", { desc = "Git: Close conflict diff" })
map("n", "<leader>gdh", "<cmd>diffget //2<CR>", { desc = "Git: Accept local changes" })
map("n", "<leader>gdl", "<cmd>diffget //3<CR>", { desc = "Git: Accept remote changes" })
