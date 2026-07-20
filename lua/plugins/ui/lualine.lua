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
      local devicons = require("nvim-web-devicons")

      local click_handlers = {}

      _G.LualineHarpoonClick = function(index)
         local handler = click_handlers[index]

         if handler then
            handler()
         end
      end

      ------------------------------------------------------------------------
      -- Helpers
      ------------------------------------------------------------------------

      local function macro_recording()
         local register = vim.fn.reg_recording()

         if register == "" then
            return ""
         end

         return "󰑋 REC @" .. register
      end

      local function escape_statusline(text)
         return text:gsub("%%", "%%%%")
      end

      local function normalize_path(path)
         if not path or path == "" then
            return ""
         end

         return vim.fs.normalize(
            vim.fn.fnamemodify(path, ":p")
         )
      end

      local function get_highlight_color(group, attribute)
         local highlight = vim.api.nvim_get_hl(0, {
            name = group,
            link = false,
         })

         return highlight[attribute]
      end

      local function get_file_icon(filename)
         local extension = vim.fn.fnamemodify(filename, ":e")

         local icon = devicons.get_icon(
            filename,
            extension,
            {
               default = true,
            }
         )

         return icon or "󰈙"
      end

      local function is_modified(path)
         local absolute_path = normalize_path(path)

         for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
            local buffer_path = normalize_path(
               vim.api.nvim_buf_get_name(buffer)
            )

            if buffer_path == absolute_path then
               return vim.bo[buffer].modified
            end
         end

         return false
      end

      ------------------------------------------------------------------------
      -- Harpoon tabline component
      ------------------------------------------------------------------------

      local function harpoon_tabline()
         local ok, harpoon = pcall(require, "harpoon")

         if not ok then
            return ""
         end

         local list = harpoon:list()
         local current_buffer = vim.api.nvim_get_current_buf()
         local current_file = normalize_path(
            vim.api.nvim_buf_get_name(current_buffer)
         )

         local components = {}
         local current_is_harpooned = false

         click_handlers = {}

         for index = 1, list:length() do
            local item = list:get(index)

            if item then
               local value = item.value

               if value and value ~= "" then
                  local path = normalize_path(value)
                  local filename = vim.fn.fnamemodify(path, ":t")
                  local icon = get_file_icon(filename)
                  local modified =
                     is_modified(path) and " ●" or ""

                  local highlight

                  if path == current_file then
                     highlight =
                        "%#LualineHarpoonActive#"

                     current_is_harpooned = true
                  else
                     highlight =
                        "%#LualineHarpoonInactive#"
                  end

                  click_handlers[index] = function()
                     harpoon:list():select(index)
                  end

                  local entry = string.format(
                     "%%%d@v:lua.LualineHarpoonClick@"
                        .. "%s %d %s %s%s %%X",
                     index,
                     highlight,
                     index,
                     icon,
                     escape_statusline(filename),
                     modified
                  )

                  components[#components + 1] = entry
               end
            end
         end

         ---------------------------------------------------------------------
         -- Show the current buffer as an unnumbered item when it is not
         -- currently in Harpoon.
         ---------------------------------------------------------------------

         if current_file ~= "" and not current_is_harpooned then
            local filename =
               vim.fn.fnamemodify(current_file, ":t")

            local icon = get_file_icon(filename)
            local modified =
               vim.bo[current_buffer].modified and " ●" or ""

            local current_entry = string.format(
               "%%#LualineCurrentBuffer# %s %s%s ",
               icon,
               escape_statusline(filename),
               modified
            )

            components[#components + 1] = current_entry
         end

         if #components == 0 then
            return "%#LualineHarpoonEmpty#  Harpoon is empty "
         end

         return table.concat(
            components,
            "%#LualineHarpoonSeparator# │ "
         )
      end

      ------------------------------------------------------------------------
      -- Highlights
      ------------------------------------------------------------------------

      local function set_lualine_highlights()
         local normal_fg =
            get_highlight_color("Normal", "fg")

         local normal_bg =
            get_highlight_color("Normal", "bg")

         local comment_fg =
            get_highlight_color("Comment", "fg")

         local string_fg =
            get_highlight_color("String", "fg")

         local identifier_fg =
            get_highlight_color("Identifier", "fg")

         local editor_bg = normal_bg or "NONE"

         ---------------------------------------------------------------------
         -- Top tabline
         ---------------------------------------------------------------------

         vim.api.nvim_set_hl(0, "TabLine", {
            fg = normal_fg,
            bg = "NONE",
         })

         vim.api.nvim_set_hl(0, "TabLineSel", {
            fg = string_fg or normal_fg,
            bg = "NONE",
            bold = true,
         })

         vim.api.nvim_set_hl(0, "TabLineFill", {
            fg = comment_fg or normal_fg,
            bg = "NONE",
         })

         vim.api.nvim_set_hl(0, "LualineHarpoonActive", {
            fg = string_fg or normal_fg,
            bg = "NONE",
            bold = true,
         })

         vim.api.nvim_set_hl(0, "LualineHarpoonInactive", {
            fg = normal_fg,
            bg = "NONE",
         })

         vim.api.nvim_set_hl(0, "LualineCurrentBuffer", {
            fg = identifier_fg
               or string_fg
               or normal_fg,

            bg = "NONE",
            bold = true,
            italic = true,
         })

         vim.api.nvim_set_hl(0, "LualineHarpoonSeparator", {
            fg = comment_fg or normal_fg,
            bg = "NONE",
         })

         vim.api.nvim_set_hl(0, "LualineHarpoonEmpty", {
            fg = comment_fg or normal_fg,
            bg = "NONE",
            italic = true,
         })

         ---------------------------------------------------------------------
         -- Bottom statusline
         ---------------------------------------------------------------------

         vim.api.nvim_set_hl(0, "StatusLine", {
            fg = normal_fg,
            bg = editor_bg,
         })

         vim.api.nvim_set_hl(0, "StatusLineNC", {
            fg = comment_fg or normal_fg,
            bg = editor_bg,
         })

         ---------------------------------------------------------------------
         -- Make unused Lualine sections match the editor background
         ---------------------------------------------------------------------

         for _, section in ipairs({
            "b",
            "c",
            "x",
            "y",
         }) do
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

               local highlight = vim.api.nvim_get_hl(0, {
                  name = group,
                  link = false,
               })

               if next(highlight) ~= nil then
                  highlight.bg = editor_bg
                  highlight.ctermbg = nil

                  vim.api.nvim_set_hl(
                     0,
                     group,
                     highlight
                  )
               end
            end
         end
      end

      ------------------------------------------------------------------------
      -- Lualine setup
      ------------------------------------------------------------------------

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
               {
                  "branch",
                  color = { bg = "NONE" },
               },
               {
                  "diff",
                  color = { bg = "NONE" },
               },
               {
                  "diagnostics",
                  color = { bg = "NONE" },
               },
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
            lualine_y = {
               -- {
               --    "datetime",
               --    style = "%H:%M",
               --
               --    separator = {
               --       left = "",
               --       right = "",
               --    },
               --    right_padding = 2,
               --    color = function()
               --       return {
               --          fg = get_highlight_color("lualine_a_normal", "fg"),
               --          bg = get_highlight_color("lualine_a_normal", "bg"),
               --          gui = "bold",
               --       }
               --    end,
               -- },
            },

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
                  harpoon_tabline,
                  padding = 0,

                  color = {
                     bg = "NONE",
                  },
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

      ------------------------------------------------------------------------
      -- Initial refresh
      ------------------------------------------------------------------------

      vim.schedule(function()
         set_lualine_highlights()

         lualine.refresh({
            place = {
               "statusline",
               "tabline",
            },
            force = true,
         })
      end)

      ------------------------------------------------------------------------
      -- Refresh after changing colorscheme
      ------------------------------------------------------------------------

      vim.api.nvim_create_autocmd("ColorScheme", {
         callback = function()
            vim.schedule(function()
               set_lualine_highlights()

               lualine.refresh({
                  place = {
                     "statusline",
                     "tabline",
                  },
                  force = true,
               })
            end)
         end,
      })

      ------------------------------------------------------------------------
      -- Refresh active and modified file state
      ------------------------------------------------------------------------

      vim.api.nvim_create_autocmd({
         "BufEnter",
         "BufWritePost",
         "BufModifiedSet",
         "BufFilePost",
      }, {
         callback = function()
            lualine.refresh({
               place = {
                  "statusline",
                  "tabline",
               },
               force = true,
            })
         end,
      })
   end,
}
