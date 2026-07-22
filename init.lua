require("config")
require("plugins")

if vim.env.NVIM_RANGER == "1" then
   vim.cmd.colorscheme("catppuccin-frappe")
else
   vim.cmd.colorscheme("kanagawa")
end
