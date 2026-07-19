local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazy_path) then
   vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazy_path,
   })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup({
   { import = "plugins.coding" },
   { import = "plugins.editor" },
   { import = "plugins.integrations" },
   { import = "plugins.languages" },
   { import = "plugins.navigation" },
   { import = "plugins.ui" },
}, {
   install = {
      colorscheme = { "kanagawa" },
   },
   checker = {
      enabled = true,
      notify = false,
   },
   change_detection = {
      notify = true,
   },
   ui = {
      border = "double",
      size = {
         width = 0.8,
         height = 0.8,
      },
   },
})
