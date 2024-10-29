return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "github/copilot.vim",
    lazy = false,
    config = function()
      require "configs.copilot"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require "configs.gitsigns"
    end,
  },
   {
      "tpope/vim-fugitive",
      lazy = false,
      config = function()
         require "configs.fugitive"
      end,
   },
   {
      "giusgad/pets.nvim",
      dependencies = { "MunifTanjim/nui.nvim", "giusgad/hologram.nvim" },
      lazy = false,
      config = function()
         require "configs.pets"
      end,
   },
  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
