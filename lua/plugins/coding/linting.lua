return {
   "mfussenegger/nvim-lint",
   -- lazy = true,
   event = { "BufReadPre", "BufNewFile", "BufWritePost", "TextChanged", "InsertLeave" }, -- to disable, comment this out
   config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
         javascript = { "eslint_d" },
         typescript = { "eslint_d" },
         javascriptreact = { "eslint_d" },
         typescriptreact = { "eslint_d" },
         svelte = { "eslint_d" },
         cpp = { "cpplint" },
         css = { "stylelint" },
         html = { "htmlhint" },
      }

      require("languages.systemverilog").setup_linter(lint)

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" }, {
         group = lint_augroup,
         callback = function()
            lint.try_lint()
         end,
      })

      vim.keymap.set("n", "<leader>l", function()
         lint.try_lint()
      end, { desc = "Linter: Trigger linting for current file" })
   end,
}
