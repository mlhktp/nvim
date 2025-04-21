return {
   {
      "nvim-treesitter/nvim-treesitter",
      event = { "BufReadPre", "BufNewFile" },
      build = ":TSUpdate",
      dependencies = {
         "windwp/nvim-ts-autotag",
         "p00f/nvim-ts-rainbow",
      },
      opts = {
            highlight = {
                enable = true,
                disable = { "verilog", "systemverilog" }, -- list of languages to disable highlighting for
                -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
                --  If you are experiencing weird indenting issues, add the language to
                --  the list of additional_vim_regex_highlighting and disabled languages for indent.
                additional_vim_regex_highlighting = { 'ruby' },
            },
            -- enable syntax highlighting
            -- highlight = {
            --     enable = true,
            -- },
            -- rainbow = {
            --     enable = true,
            --     -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            --     extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            --     max_file_lines = nil, -- Do not enable for files with more than n lines, int
            --     -- colors = {}, -- table of hex strings
            --     -- termcolors = {} -- table of colour name strings
            -- },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
               enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
               "json",
               "rust",
               "javascript",
               "typescript",
               "tsx",
               "yaml",
               "html",
               "css",
               "prisma",
               "markdown",
               "markdown_inline",
               "svelte",
               "graphql",
               "bash",
               "lua",
               "vim",
               "dockerfile",
               "gitignore",
               "query",
               "verilog",
            },
            incremental_selection = {
               enable = true,
               keymaps = {
                  init_selection = "<C-space>",
                  node_incremental = "<C-space>",
                  scope_incremental = false,
                  node_decremental = "<bs>",
               },
            },
            -- enable nvim-ts-context-commentstring plugin for commenting tsx and jsx
            --context_commentstring = {
            --  enable = true,
            --  enable_autocmd = false,
            --},
      },
      config = function(_, opts)
         -- import nvim-treesitter plugin
         local treesitter = require("nvim-treesitter.configs")
         require'night.config.setup_systemverilog'.setupTreesitter(opts)

         -- configure treesitter
         treesitter.setup(opts)
      end,
   },
}
