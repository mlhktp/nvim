return {
   "folke/zen-mode.nvim",
   config = function()
      require("zen-mode").setup({
         -- your configuration comes here
         -- or leave it empty to use the default settings
         -- refer to the configuration section below
         window = {
            backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
            -- height and width can be:
            -- * an absolute number of cells when > 1
            -- * a percentage of the width / height of the editor when <= 1
            -- * a function that returns the width or the height
            width = 160, -- width of the Zen window
            height = 1, -- height of the Zen window
            -- by default, no options are changed for the Zen window
            -- uncomment any of the options below, or add other vim.wo options you want to apply
            options = {
               signcolumn = "no", -- disable signcolumn
               number = false, -- disable number column
               relativenumber = false, -- disable relative numbers
               cursorline = false, -- disable cursorline
               cursorcolumn = false, -- disable cursor column
               foldcolumn = "0", -- disable fold column
               list = false, -- disable whitespace characters
            },
         },
         plugins = {
            -- disable some global vim options (vim.o...)
            -- comment the lines to not apply the options
            options = {
               enabled = true,
               ruler = false, -- disables the ruler text in the cmd line area
               showcmd = false, -- disables the command in the last line of the screen
               -- you may turn on/off statusline in zen mode by setting 'laststatus'
               -- statusline will be shown only if 'laststatus' == 3
               laststatus = 0, -- turn off the statusline in zen mode
            },
            twilight = { enabled = true },
            gitsigns = false,
            tmux = true,
            kitty = false,
            alacritty = false,
            wezterm = false,
            neovide = false,
         },
         on_open = function()
            -- Save and override line wrap settings
            vim.b._zen_mode_prev = {
               wrap = vim.wo.wrap,
               linebreak = vim.wo.linebreak,
               whichwrap = vim.o.whichwrap,
            }

            -- Apply Zen Mode settings
            vim.wo.wrap = true
            vim.wo.linebreak = true
            vim.o.whichwrap = vim.o.whichwrap .. ",h,l,<,>,[,]"

            -- Remap navigation keys
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "j", "gj", opts)
            vim.keymap.set("n", "k", "gk", opts)
            vim.keymap.set("n", "0", "g0", opts)
            vim.keymap.set("n", "$", "g$", opts)
         end,
         on_close = function()
            local prev = vim.b._zen_mode_prev or {}

            vim.wo.wrap = prev.wrap or false
            vim.wo.linebreak = prev.linebreak or false
            vim.o.whichwrap = prev.whichwrap or "b,s"

            -- Remove remaps
            vim.keymap.del("n", "j")
            vim.keymap.del("n", "k")
            vim.keymap.del("n", "0")
            vim.keymap.del("n", "$")
         end,
      })
   end,
}
