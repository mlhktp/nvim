return {
   "uga-rosa/cmp-dictionary",
   config = function()
      require("cmp").setup({
         paths = { "/usr/share/dict/words" },
         exact_length = 2,
      })
   end,
}
