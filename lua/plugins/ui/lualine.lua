return {
   "nvim-lualine/lualine.nvim",
   event = "VeryLazy",

   dependencies = {
      "nvim-tree/nvim-web-devicons",
      {
         "ThePrimeagen/harpoon",
         branch = "harpoon2",
      },
   },

   init = function()
      vim.opt.laststatus = 0
   end,

   config = function()
      vim.opt.laststatus = 3
      vim.opt.showtabline = 2

      local lualine = require("lualine")
      local harpoon_tabline = require("ui.harpoon_tabline")

      local function highlight_color(group, attribute)
         return vim.api.nvim_get_hl(0, {
            name = group,
            link = false,
         })[attribute]
      end

      local function macro_recording()
         local register = vim.fn.reg_recording()

         if register == "" then
            return ""
         end

         return "󰑋 REC @" .. register
      end

      local function match_editor_background()
         local editor_bg = highlight_color("Normal", "bg") or "NONE"

         vim.api.nvim_set_hl(0, "StatusLine", {
            fg = highlight_color("Normal", "fg"),
            bg = editor_bg,
         })

         vim.api.nvim_set_hl(0, "StatusLineNC", {
            fg = highlight_color("Comment", "fg")
               or highlight_color("Normal", "fg"),
            bg = editor_bg,
         })

         for _, section in ipairs({ "b", "c", "x", "y" }) do
            for _, mode in ipairs({
               "normal",
               "inactive",
               "insert",
               "visual",
               "replace",
               "command",
               "terminal",
            }) do
               local group = string.format(
                  "lualine_%s_%s",
                  section,
                  mode
               )

               local current = vim.api.nvim_get_hl(0, {
                  name = group,
                  link = false,
               })

               if next(current) ~= nil then
                  current.bg = editor_bg
                  current.ctermbg = nil
                  vim.api.nvim_set_hl(0, group, current)
               end
            end
         end
      end

      lualine.setup({
         options = {
            theme = "auto",
            component_separators = "",

            section_separators = {
               left = "",
               right = "",
            },

            disabled_filetypes = {
               "alpha",
            },
         },

         sections = {
            lualine_a = {
               {
                  "mode",
                  separator = {
                     left = "",
                     right = "",
                  },
                  right_padding = 2,
               },
            },

            lualine_b = {
               { "branch", color = { bg = "NONE" } },
               { "diff", color = { bg = "NONE" } },
               { "diagnostics", color = { bg = "NONE" } },
            },

            lualine_c = {},

            lualine_x = {
               {
                  macro_recording,
                  cond = function()
                     return vim.fn.reg_recording() ~= ""
                  end,
                  color = {
                     fg = "#ff5555",
                     bg = "NONE",
                     bold = true,
                  },
               },
            },

            lualine_y = {},
            lualine_z = {},
         },

         inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
         },

         tabline = {
            lualine_a = {},
            lualine_b = {},

            lualine_c = {
               {
                  harpoon_tabline.render,
                  padding = 0,
                  color = { bg = "NONE" },
               },
            },

            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
         },

         extensions = {
            "nvim-tree",
            "fzf",
         },
      })

      harpoon_tabline.setup()

      vim.schedule(function()
         match_editor_background()
         harpoon_tabline.refresh()
      end)

      vim.api.nvim_create_autocmd("ColorScheme", {
         group = vim.api.nvim_create_augroup("LualineColors", {
            clear = true,
         }),
         callback = function()
            vim.schedule(match_editor_background)
         end,
      })
   end,
}
