local harpoon = require("harpoon")

harpoon:setup()

local function refresh_harpoon_tabline()
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

------------------------------------------------------------------------
-- Compact Harpoon
--
-- Harpoon normally leaves nil slots after removing an item:
--
--   1 2 3 4 5
--       remove 3
--   1 2 _ 4 5
--
-- This converts it to:
--
--   1 2 3 4
------------------------------------------------------------------------

local function compact_harpoon_list(list)
   local displayed = {}
   local has_holes = false

   for index = 1, list:length() do
      local item = list:get(index)

      if item then
         displayed[#displayed + 1] = list.config.display(item)
      else
         has_holes = true
      end
   end

   if has_holes then
      list:resolve_displayed(displayed, #displayed)
   end
end

local function remove_current_harpoon_item()
   local list = harpoon:list()

   list:remove()
   compact_harpoon_list(list)
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

local function remove_current_harpoon_item()
   local list = harpoon:list()
   local removed_index = get_current_harpoon_index(list)

   if not removed_index then
      return false
   end

   list:remove_at(removed_index)
   compact_harpoon_list(list)

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
-- Telescope
------------------------------------------------------------------------

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local function make_harpoon_finder(list)
   local results = {}

   for index = 1, list:length() do
      local item = list:get(index)

      if item and item.value and item.value ~= "" then
         results[#results + 1] = {
            harpoon_index = index,
            path = item.value,
         }
      end
   end

   return finders.new_table({
      results = results,

      entry_maker = function(item)
         local filename = vim.fn.fnamemodify(item.path, ":t")

         return {
            value = item.path,
            path = item.path,
            filename = item.path,
            ordinal = item.path,

            display = string.format(
               "%d  %s",
               item.harpoon_index,
               filename
            ),

            harpoon_index = item.harpoon_index,
         }
      end,
   })
end

local function toggle_telescope(list)
   pickers.new({}, {
      prompt_title = "Harpoon",
      finder = make_harpoon_finder(list),
      previewer = conf.file_previewer({}),
      sorter = conf.generic_sorter({}),

   attach_mappings = function(prompt_bufnr, map)
      local function close_picker()
         actions.close(prompt_bufnr)
      end

      map("i", "<C-e>", close_picker)
      map("n", "<C-e>", close_picker)

      actions.select_default:replace(function()
         local entry = action_state.get_selected_entry()

         if not entry then
            return
         end

         actions.close(prompt_bufnr)
         list:select(entry.harpoon_index)
      end)

      local function remove_selected()
         local entry = action_state.get_selected_entry()

         if not entry then
            return
         end

         local removed =
            remove_harpoon_item_at(entry.harpoon_index)

         if not removed then
            return
         end

         local picker =
            action_state.get_current_picker(prompt_bufnr)

         picker:refresh(
            make_harpoon_finder(list),
            {
               reset_prompt = false,
            }
         )
      end

      map("i", "<C-q>", remove_selected)
      map("n", "<C-q>", remove_selected)

      return true
   end,
   }):find()
end

vim.keymap.set("n", "<C-e>", function()
   toggle_telescope(harpoon:list())
end, {
   desc = "Open Harpoon picker",
})

------------------------------------------------------------------------
-- Compact previously saved lists containing old nil slots
------------------------------------------------------------------------

vim.schedule(function()
   compact_harpoon_list(harpoon:list())
   refresh_harpoon_tabline()
end)

