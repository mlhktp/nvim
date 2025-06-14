-- This file contains a table with functions that configure the
-- LSP, linter, and treesitter plugins for use with SystemVerilog.
-- It is called from within the plugin spec themselves.
-- For example, you will find require'setup_systemverilog'.setupLsp() within
-- lua\setup_nvim_lspconfig.lua.

local setup_systemverilog = {}

function setup_systemverilog.setupLsp()
   local on_attach = function(client, bufnr)
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
   end

   local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150,
   }

   require'lspconfig'.verible.setup {
      on_attach = on_attach,
      flags = lsp_flags,
      format_on_save = false,
      cmd = { 'verible-verilog-ls', '--rules_config_search', '--indentation_spaces=3', '--column_limit=200' },
      root_dir = require('lspconfig').util.root_pattern({'.git', 'verilator.f'}),
   }
end

function setup_systemverilog.setupLinter(lint)

    lint.linters_by_ft = {
        systemverilog = { 'verilator' },
        verilog = { 'verilator' },
    }

    local verilator = lint.linters.verilator


    -- If the following is not true the warning MODDUP appears
    verilator.append_fname = false

    -- Add/change arguments for Verilator here.
    -- You can also use or re-use a verilator.f file (see example\verilator.f)
    -- placed anywhere between CWD and your home dir and it
    -- will be read by Verilator

    -- The arguments below are the default provided by nvim-lint
    -- (https://github.com/mfussenegger/nvim-lint/blob/master/lua/lint/linters/verilator.lua)
    -- with the exception of the '-f' and corresponding path to verilator.f
    verilator.args = {
        "-sv",
        "--lint-only",
        '-f',
        vim.fs.find('verilator.f', {upward = true, stop = vim.env.HOME})[1],
    }


    lint.linters.verilator = verilator
end



function setup_systemverilog.setupTreesitter(opts)
    table.insert(opts.ensure_installed, 'verilog')

    -- Uncomment below to disable highlighting via Treesitter
    -- Sometimes the highlighting provided via treesitter isnt great, so ymmv.
    table.insert(opts.highlight.disable, {'verilog', 'systemverilog'})
end

return setup_systemverilog

