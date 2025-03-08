return
{
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = {
                    hidden = true, -- Show hidden files (like `.config`)
                    no_ignore = true, -- Include files ignored by `.gitignore`
                    file_ignore_patterns = {".git/*", "./.git/", "./node_modules/*", "node_modules", "^node_modules/*", "node_modules/*"}
                },
                live_grep = {
                    additional_args = function()
                        return {
                            "--hidden", -- Include hidden files
                            "--glob", "!.git/*" -- Exclude `.git` directory
                        }
                    end
                },
                colorscheme = {
                    enable_preview = true,
                },
            },
        })
    end,
}

