return {
   "neovim/nvim-lspconfig",
   event = { "BufReadPre", "BufNewFile" },
   config = function()
      -- import lspconfig plugin
      local lspconfig = require("lspconfig")

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

            if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
               map('<leader>th', function()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
               end, '[T]oggle Inlay [H]ints')
            end
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
         signs = true,
         underline = true,
         update_in_insert = false,
         severity_sort = true,
      })

      -- Change the Diagnostic symbols in the sign column (gutter)
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
         local hl = "DiagnosticSign" .. type
         vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      mason_lspconfig.setup_handlers({
         -- default handler for installed servers
         function(server_name)
            lspconfig[server_name].setup({
               capabilities = capabilities,
            })
         end,
         ["svelte"] = function()
            -- configure svelte server
            lspconfig["svelte"].setup({
               capabilities = capabilities,
               on_attach = function(client, bufnr)
                  vim.api.nvim_create_autocmd("BufWritePost", {
                     pattern = { "*.js", "*.ts" },
                     callback = function(ctx)
                        -- Here use ctx.match instead of ctx.file
                        client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
                     end,
                  })
               end,
            })
         end,

         ["graphql"] = function()
            -- configure graphql language server
            lspconfig["graphql"].setup({
               capabilities = capabilities,
               filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
            })
         end,
         ["emmet_ls"] = function()
            -- configure emmet language server
            lspconfig["emmet_ls"].setup({
               capabilities = capabilities,
               filetypes = {
                  "html",
                  "typescriptreact",
                  "javascriptreact",
                  "css",
                  "sass",
                  "scss",
                  "less",
                  "svelte",
               },
            })
         end,
         ["lua_ls"] = function()
            -- configure lua server (with special settings)
            lspconfig["lua_ls"].setup({
               capabilities = capabilities,
               settings = {
                  Lua = {
                     -- make the language server recognize "vim" global
                     diagnostics = {
                        globals = { "vim" },
                     },
                     completion = {
                        callSnippet = "Replace",
                     },
                  },
               },
            })
         end,
         -- ["matlab_ls"] = function()
         --    lspconfig["matlab_ls"].setup({
         --       filetypes = { "matlab" },
         --       settings = {
         --          matlab = {
         --             installPath = "/usr/local/MATLAB/R2024b/",
         --          },
         --       },
         --    })
         -- end,
      })
   end,
}
