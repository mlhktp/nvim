return {
   "hrsh7th/nvim-cmp",
   dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
   },
   config = function()
      -- Set up nvim-cmp.
      local cmp = require("cmp")

      cmp.setup({
         formatting = {
            format = require("lspkind").cmp_format({
               mode = "symbol",
               maxwidth = 50,
               ellipsis_char = "...",
               symbol_map = { Copilot = "", dictionary = "󰂺" },
               menu = {
                  dictionary = "[Dict]",
                  nvim_lsp = "[LSP]",
                  emoji = "[Emoji]",
                  path = "[Path]",
                  calc = "[Calc]",
                  cmp_tabnine = "[TabNine]",
                  luasnip = "[Snippet]",
                  buffer = "[Buffer]",
                  tmux = "[TMUX]",
                  copilot = "[Copilot]",
                  treesitter = "[TreeSitter]",
               },
            }),
            fields = { "kind", "abbr", "menu" },
         },

         window = {
            completion = cmp.config.window.bordered(),
         },

         mapping = cmp.mapping.preset.insert({
            ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            -- ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            -- ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<C-Enter>"] = cmp.mapping.confirm({ select = true }),
            ["<C-l>"] = function(fallback)
               cmp.mapping.abort()
               local copilot_keys = vim.fn["copilot#Accept"]()
               if copilot_keys ~= "" then
                  vim.api.nvim_feedkeys(copilot_keys, "i", true)
               else
                  fallback()
               end
            end,
         }),

         sources = cmp.config.sources({
            { name = "dictionary", keyword_length = 2 },
            { name = "nvim_lsp" },
            { name = "copilot" },
            { name = "luasnip" }, -- Only use the snippet engine you have enabled
         }, {
            { name = "buffer" },
         }),
      })

      -- Git commit completion
      cmp.setup.filetype("gitcommit", {
         sources = cmp.config.sources({
            { name = "git" },
         }, {
               { name = "buffer" },
            }),
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
         mapping = cmp.mapping.preset.cmdline(),
         sources = {
            { name = "buffer" },
         },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(":", {
         mapping = cmp.mapping.preset.cmdline(),
         sources = cmp.config.sources({
            { name = "path" },
         }, {
               { name = "cmdline" },
            }),
      })

      -- Set up lspconfig.
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
      --require("lspconfig")["<YOUR_LSP_SERVER>"].setup({
      --  capabilities = capabilities,
      --})
   end,
}
