local map = vim.keymap.set

map("n", "<leader>zm", "<cmd>ZenMode<CR>", { desc = "Toggle Zen mode" })
map("n", "<leader>mt", "<cmd>MaximizerToggle<CR>", { desc = "Toggle maximized window" })

map("n", "<leader>e", "<cmd>Neotree left<CR>", { desc = "Open file explorer" })
map("n", "<leader>ef", "<cmd>Neotree float<CR>", { desc = "Open floating file explorer" })
map("n", "<leader>ec", "<cmd>Neotree close<CR>", { desc = "Close file explorer" })
map("n", "<leader>ee", "<cmd>Neotree float git_status git_base=main<CR>", { desc = "Open Git status explorer" })
map("n", "<M-e>", "<cmd>Neotree left toggle<CR>", { desc = "Toggle file explorer" })
map("n", "<M-S-e>", "<cmd>Neotree float toggle<CR>", { desc = "Toggle floating file explorer" })
map("n", "<M-r>", "<cmd>Neotree verilog_hierarchy left toggle<CR>", { desc = "Toggle Verilog hierarchy" })
map("n", "<M-S-r>", "<cmd>Neotree verilog_hierarchy float toggle<CR>", {
   desc = "Toggle floating Verilog hierarchy",
})

map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fw", "<cmd>Telescope live_grep<CR>", { desc = "Find text" })
map("n", "<leader>fc", "<cmd>Telescope grep_string<CR>", { desc = "Find word under cursor" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find help" })

map("n", "<leader>t", "<cmd>TagbarToggle<CR>", { desc = "Toggle tag outline" })
map("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore workspace session" })
map("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save workspace session" })
map("n", "<leader>cc", "<cmd>Themery<CR>", { desc = "Choose colorscheme" })
map("n", "<leader>ch", vim.diagnostic.open_float, { desc = "Show diagnostic" })
