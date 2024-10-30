require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("i", "<C-l>",
  function ()
    vim.fn.feedkeys(vim.fn["copilot#Accept"](), "")
  end,
  {
    desc = "Copilot Accept",
    replace_keycodes = true,
    nowait = true,
    silent = true,
    expr = true,
    noremap = true
  }
)
map({ "n", "i", "v" }, "<leader>mft", "<cmd> FortuneToggle <cr>", { desc = "Toggle Fortune" })
map({ "n", "i", "v" }, "<leader>mfn", "<cmd> FortuneNext <cr>", { desc = "Next Fortune" })
map({ "n", "i", "v" }, "<leader>mfn", "<cmd> FortuneNext <cr>", { desc = "Next Fortune" })
map({ "n", "i", "v" }, "<leader>mpi", "<cmd> PetsIdleToggle <cr>", { desc = "Pets Idle Toggle" })
-- PetsNew random_name
map({ "n", "i", "v" }, "<leader>mpn", "<cmd>lua PetsNewWithTimestamp()<CR>", { desc = "New Pet" })

function PetsNewWithTimestamp()
  local timestamp = os.time(os.date("!*t"))
  vim.cmd("PetsNew pet_" .. timestamp)
end

map({ "n", "i", "v" }, "<leader>mpk", "<cmd> PetsKillAll <cr>", { desc = "Kill All Pets" })

map({ "n", "i", "v" }, "<leader>gp", "<cmd> Gitsigns preview_hunk <cr>", { desc = "Gitsigns Preview Hunk" })
map({ "n", "i", "v" }, "<leader>gi", "<cmd> Gitsigns preview_hunk_inline <cr>", { desc = "Gitsigns Preview Hunk Inline" })
map({ "n", "i", "v" }, "<leader>gs", "<cmd> Gitsigns stage_hunk <cr>", { desc = "Gitsigns Stage Hunk" })
map({ "n", "i", "v" }, "<leader>gn", "<cmd> Gitsigns next_hunk <cr>", { desc = "Gitsigns Next Hunk" })
map({ "n", "i", "v" }, "<leader>gb", "<cmd> Gitsigns prev_hunk <cr>", { desc = "Gitsigns Previous Hunk" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
