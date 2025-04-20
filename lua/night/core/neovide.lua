
if vim.g.neovide then
    -- Put anything you want to happen only in Neovide here
   --
   vim.o.guifont = "FiraCode Nerd Font:h8.5:x8.0" -- text below applies for VimScript
   vim.g.neovide_padding_top = 20
   vim.g.neovide_padding_bottom = 30
   vim.g.neovide_padding_right = 20
   vim.g.neovide_padding_left = 20
   vim.keymap.set({ "n", "v" }, "<C-+>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>")
   vim.keymap.set({ "n", "v" }, "<C-_>", ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>")
   -- font line size 140%
end

