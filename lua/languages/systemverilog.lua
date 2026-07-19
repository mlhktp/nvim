local M = {}

function M.setup_lsp()
   vim.lsp.config("verible", {
      on_attach = function(_, buffer)
         vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"
      end,
      flags = { debounce_text_changes = 150 },
      format_on_save = false,
      cmd = {
         "verible-verilog-ls",
         "--rules_config_search",
         "--indentation_spaces=3",
         "--column_limit=200",
      },
      root_markers = { ".git", "verilator.f" },
   })
end

function M.setup_linter(lint)
   lint.linters_by_ft.systemverilog = { "verilator" }
   lint.linters_by_ft.verilog = { "verilator" }

   local verilator = lint.linters.verilator
   local verilator_file = vim.fs.find("verilator.f", { upward = true, stop = vim.env.HOME })[1]

   verilator.append_fname = false
   verilator.args = { "-sv", "--lint-only" }

   if verilator_file then
      vim.list_extend(verilator.args, { "-f", verilator_file })
   end

   lint.linters.verilator = verilator
end

function M.setup_treesitter(opts)
   if not vim.tbl_contains(opts.ensure_installed, "verilog") then
      table.insert(opts.ensure_installed, "verilog")
   end

   for _, language in ipairs({ "verilog", "systemverilog" }) do
      if not vim.tbl_contains(opts.highlight.disable, language) then
         table.insert(opts.highlight.disable, language)
      end
   end
end

return M
