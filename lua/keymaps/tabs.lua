local harpoon = require("harpoon")
local harpoon_history = require("config.harpoon_history")
local harpoon_tabline = require("ui.harpoon_tabline")

harpoon:setup()

local function refresh_harpoon_tabline()
   harpoon_tabline.refresh()
end

local function normalize_path(path)
   if not path or path == "" then
      return ""
   end

   return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function get_current_harpoon_index(list)
   local current_file = normalize_path(
      vim.api.nvim_buf_get_name(0)
   )

   for index = 1, list:length() do
      local item = list:get(index)

      if item and normalize_path(item.value) == current_file then
         return index
      end
   end

   return nil
end

local function remove_harpoon_item_at(index)
   local list = harpoon:list()

   if not list:get(index) then
      return false
   end

   harpoon_history.remove(list, index)
   refresh_harpoon_tabline()

   return true
end

local function remove_current_harpoon_item()
   local list = harpoon:list()
   local removed_index = get_current_harpoon_index(list)

   if not removed_index then
      return false
   end

   remove_harpoon_item_at(removed_index)

   local remaining = list:length()

   if remaining > 0 then
      -- Go to the previous item. When removing item 1,
      -- stay at the new item 1.
      local previous_index = math.max(1, removed_index - 1)

      list:select(previous_index)
   end

   return true
end

------------------------------------------------------------------------
-- Automatically refresh Lualine after Harpoon changes
------------------------------------------------------------------------

harpoon:extend({
   ADD = refresh_harpoon_tabline,
   REMOVE = refresh_harpoon_tabline,
   REPLACE = refresh_harpoon_tabline,
   REORDER = refresh_harpoon_tabline,
   LIST_CHANGE = refresh_harpoon_tabline,
})

------------------------------------------------------------------------
-- Keymaps
------------------------------------------------------------------------

vim.keymap.set("n", "<C-s>", function()
   harpoon:list():add()
end, {
   desc = "Add current file to Harpoon",
})

vim.keymap.set("n", "<C-q>", function()
   remove_current_harpoon_item()
end, {
   desc = "Remove current file from Harpoon",
})

vim.keymap.set("n", "<C-m>", function()
   if harpoon_history.restore(harpoon:list()) then
      refresh_harpoon_tabline()
   end
end, {
   desc = "Reopen last closed Harpoon tab",
})

for index = 1, 9 do
   vim.keymap.set("n", "<C-" .. index .. ">", function()
      harpoon:list():select(index)
   end, {
      desc = "Select Harpoon file " .. index,
   })
end

vim.keymap.set("n", "<C-0>", function()
   local list = harpoon:list()
   local last_index = list:length()

   if last_index > 0 then
      list:select(last_index)
   end
end, {
   desc = "Select last Harpoon file",
})

vim.keymap.set("n", "<C-i>", function()
   harpoon:list():prev({
      ui_nav_wrap = true,
   })
end, {
   desc = "Previous Harpoon file",
})

vim.keymap.set("n", "<C-o>", function()
   harpoon:list():next({
      ui_nav_wrap = true,
   })
end, {
   desc = "Next Harpoon file",
})

vim.keymap.set("n", "<Tab>", function()
   harpoon:list():next({
      ui_nav_wrap = true,
   })
end, {
   desc = "Next Harpoon file",
})

vim.keymap.set("n", "<S-Tab>", function()
   harpoon:list():prev({
      ui_nav_wrap = true,
   })
end, {
   desc = "Previous Harpoon file",
})

------------------------------------------------------------------------
-- Compact previously saved lists containing old nil slots
------------------------------------------------------------------------

vim.schedule(function()
   harpoon_history.compact(harpoon:list())
   refresh_harpoon_tabline()
end)
