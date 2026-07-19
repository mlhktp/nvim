return {
   {
      "lewis6991/gitsigns.nvim",
      enabled = vim.fn.executable("git") == 1,
      event = { "BufReadPre", "BufNewFile" },
      opts = {
         worktrees = vim.g.git_worktrees,
      },
   },
   { "tpope/vim-fugitive" },
}
