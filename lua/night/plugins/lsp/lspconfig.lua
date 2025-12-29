return {
   "neovim/nvim-lspconfig",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      -- import lspconfig plugin
      -- local lspconfig = require("lspconfig")

      -- import mason_lspconfig plugin
      local mason_lspconfig = require("mason-lspconfig")

      -- import cmp-nvim-lsp plugin
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      local keymap = vim.keymap -- for conciseness

      vim.api.nvim_create_autocmd("LspAttach", {
         group = vim.api.nvim_create_augroup("UserLspConfig", {}),
         callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
               local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
               vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                  buffer = ev.buf,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.document_highlight,
               })

               vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                  buffer = ev.buf,
                  group = highlight_augroup,
                  callback = vim.lsp.buf.clear_references,
               })

               vim.api.nvim_create_autocmd('LspDetach', {
                  group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                  callback = function(event2)
                     vim.lsp.buf.clear_references()
                     vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                  end,
               })
            end

            -- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            --    keymap('<leader>th', function()
            --       vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            --    end, '[T]oggle Inlay [H]ints')
            -- end
         end
      })

      require("night.config.setup_systemverilog").setupLsp()

      -- used to enable autocompletion (assign to every lsp server config)
      local capabilities = cmp_nvim_lsp.default_capabilities()
      vim.diagnostic.config({
         virtual_text = {
            spacing = 2,
            prefix = '●',
            severity = nil,
            source = "always",
         },
         signs = {
            text = {
               [vim.diagnostic.severity.ERROR] = " ",
               [vim.diagnostic.severity.WARN]  = " ",
               [vim.diagnostic.severity.INFO]  = " ",
               [vim.diagnostic.severity.HINT]  = "󰠠 ",
            },
         },
         underline = true,
         update_in_insert = false,
         severity_sort = true,
      })

      mason_lspconfig.setup({})

      -- local servers = mason_lspconfig.get_installed_servers()
      -- for _, server_name in ipairs(servers) do
      --    if server_name == "svelte" then
      --       lspconfig["svelte"].setup({
      --          capabilities = capabilities,
      --          on_attach = function(client, bufnr)
      --             vim.api.nvim_create_autocmd("BufWritePost", {
      --                pattern = { "*.js", "*.ts" },
      --                callback = function(ctx)
      --                   client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
      --                end,
      --             })
      --          end,
      --       })
      --    elseif server_name == "graphql" then
      --       lspconfig["graphql"].setup({
      --          capabilities = capabilities,
      --          filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
      --       })
      --    elseif server_name == "emmet_ls" then
      --       lspconfig["emmet_ls"].setup({
      --          capabilities = capabilities,
      --          filetypes = {
      --             "html", "typescriptreact", "javascriptreact",
      --             "css", "sass", "scss", "less", "svelte",
      --          },
      --       })
      --    elseif server_name == "lua_ls" then
      --       lspconfig["lua_ls"].setup({
      --          capabilities = capabilities,
      --          settings = {
      --             Lua = {
      --                diagnostics = { globals = { "vim" } },
      --                completion = { callSnippet = "Replace" },
      --             },
      --          },
      --       })
      --    else
      --       lspconfig[server_name].setup({
      --          capabilities = capabilities,
      --       })
      --    end
      -- end
   end,
}
