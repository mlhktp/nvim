return {
   "3rd/image.nvim",
   cond = function()
      return #vim.api.nvim_list_uis() > 0
   end,
   dependencies = {
      "nvim-lua/plenary.nvim",
   },
   opts = {
      backend = "kitty",
   },
}
