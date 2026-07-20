local M = {}

local harpoon_history = require("config.harpoon_history")

local click_handlers = {}
local close_handlers = {}

local function normalize_path(path)
   if not path or path == "" then
      return ""
   end

   return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function escape_statusline(text)
   return text:gsub("%%", "%%%%")
end

local function highlight(group)
   return vim.api.nvim_get_hl(0, {
      name = group,
      link = false,
   })
end

local function color(group, attribute)
   return highlight(group)[attribute]
end

local function buffer_for_path(path)
   local wanted = normalize_path(path)

   for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
      if normalize_path(vim.api.nvim_buf_get_name(buffer)) == wanted then
         return buffer
      end
   end

   return nil
end

local function is_modified(path)
   local buffer = buffer_for_path(path)

   return buffer ~= nil and vim.bo[buffer].modified
end

local function file_icon(filename, state)
   local ok, devicons = pcall(require, "nvim-web-devicons")

   if not ok then
      return "󰈙", nil
   end

   local icon, icon_color = devicons.get_icon_color(
      filename,
      vim.fn.fnamemodify(filename, ":e"),
      { default = true }
   )

   if state == "Inactive" or not icon_color then
      return icon or "󰈙", nil
   end

   local group = "HarpoonTab" .. state .. "Icon"

   vim.api.nvim_set_hl(0, group, {
      fg = icon_color,
      bg = color("HarpoonTab" .. state, "bg"),
      bold = true,
   })

   return icon or "󰈙", group
end

local function set_tab_highlights(state, background, foreground)
   local prefix = "HarpoonTab" .. state
   local comment_fg = color("Comment", "fg") or foreground

   vim.api.nvim_set_hl(0, prefix, {
      fg = foreground,
      bg = background,
      bold = state ~= "Inactive",
   })

   vim.api.nvim_set_hl(0, prefix .. "Edge", {
      fg = comment_fg,
      bg = background,
   })

   vim.api.nvim_set_hl(0, prefix .. "Index", {
      fg = color("Number", "fg") or color("Special", "fg") or foreground,
      bg = background,
      bold = true,
   })

   vim.api.nvim_set_hl(0, prefix .. "Modified", {
      fg = color("String", "fg") or foreground,
      bg = background,
   })

   vim.api.nvim_set_hl(0, prefix .. "Close", {
      fg = comment_fg,
      bg = background,
   })
end

function M.apply_highlights()
   local normal_fg = color("Normal", "fg") or 0xffffff
   local normal_bg = color("Normal", "bg")

   local current_bg = color("CursorLine", "bg")
      or color("PmenuSel", "bg")
      or normal_bg

   local inactive_bg = color("TabLine", "bg")
      or color("StatusLineNC", "bg")
      or color("NormalFloat", "bg")
      or normal_bg

   local unlisted_bg = color("Visual", "bg")
      or color("DiffChange", "bg")
      or current_bg

   set_tab_highlights("Current", current_bg, normal_fg)
   set_tab_highlights(
      "Unlisted",
      unlisted_bg,
      color("Identifier", "fg") or color("Special", "fg") or normal_fg
   )
   set_tab_highlights(
      "Inactive",
      inactive_bg,
      color("Comment", "fg") or normal_fg
   )

   vim.api.nvim_set_hl(0, "HarpoonTabFill", {
      bg = normal_bg,
   })
end

function M.refresh()
   vim.schedule(function()
      local ok, lualine = pcall(require, "lualine")

      if ok then
         lualine.refresh({
            place = { "tabline" },
            force = true,
         })
      end

      vim.cmd("redrawtabline")
   end)
end

local function tab(state, index, filename, modified, close_handler)
   local prefix = "HarpoonTab" .. state
   local icon, icon_group = file_icon(filename, state)
   local parts = {
      "%#" .. prefix .. "Edge#▎",
   }

   if index then
      parts[#parts + 1] = string.format(
         "%%%d@v:lua.HarpoonTablineSelect@",
         index
      )

      parts[#parts + 1] = "%#" .. prefix .. "Index# " .. index
   else
      parts[#parts + 1] = "%#" .. prefix .. "#"
   end

   parts[#parts + 1] = "%#" .. prefix .. "# "

   if icon_group then
      parts[#parts + 1] = "%#" .. icon_group .. "#"
   end

   parts[#parts + 1] = icon
   parts[#parts + 1] = string.format(
      "%%#%s# %s ",
      prefix,
      escape_statusline(filename)
   )

   if index then
      parts[#parts + 1] = "%X"
   end

   if modified then
      parts[#parts + 1] = "%#" .. prefix .. "Modified#● "
   end

   if close_handler then
      parts[#parts + 1] = string.format(
         "%%%d@v:lua.%s@%%#%sClose#× %%X",
         index or 0,
         close_handler,
         prefix
      )
   end

   return table.concat(parts)
end

function M.render()
   local ok, harpoon = pcall(require, "harpoon")

   if not ok then
      return ""
   end

   local list = harpoon:list()
   local current_buffer = vim.api.nvim_get_current_buf()
   local current_path = normalize_path(vim.api.nvim_buf_get_name(current_buffer))
   local entries = {}
   local current_is_harpooned = false

   click_handlers = {}
   close_handlers = {}

   for index = 1, list:length() do
      local item = list:get(index)

      if item and item.value and item.value ~= "" then
         local item_index = index
         local path = normalize_path(item.value)
         local filename = vim.fn.fnamemodify(path, ":t")
         local state = path == current_path and "Current" or "Inactive"

         if state == "Current" then
            current_is_harpooned = true
         end

         click_handlers[item_index] = function()
            list:select(item_index)
         end

         close_handlers[item_index] = function()
            harpoon_history.remove(list, item_index)

            if list:length() > 0 then
               list:select(math.max(1, item_index - 1))
            end

            M.refresh()
         end

         entries[#entries + 1] = tab(
            state,
            item_index,
            filename,
            is_modified(path),
            "HarpoonTablineRemove"
         )
      end
   end

   if current_path ~= "" and not current_is_harpooned then
      local filename = vim.fn.fnamemodify(current_path, ":t")

      entries[#entries + 1] = tab(
         "Unlisted",
         nil,
         filename,
         vim.bo[current_buffer].modified,
         nil
      )
   end

   if #entries == 0 then
      return ""
   end

   return table.concat(entries)
end

function M.setup()
   _G.HarpoonTablineSelect = function(index)
      local handler = click_handlers[index]

      if handler then
         handler()
      end
   end

   _G.HarpoonTablineRemove = function(index)
      local handler = close_handlers[index]

      if handler then
         handler()
      end
   end

   M.apply_highlights()

   local group = vim.api.nvim_create_augroup("HarpoonTabline", {
      clear = true,
   })

   vim.api.nvim_create_autocmd("ColorScheme", {
      group = group,
      callback = function()
         vim.schedule(function()
            M.apply_highlights()
            M.refresh()
         end)
      end,
   })

   vim.api.nvim_create_autocmd({
      "BufEnter",
      "BufWritePost",
      "BufModifiedSet",
      "BufFilePost",
   }, {
      group = group,
      callback = M.refresh,
   })
end

return M
