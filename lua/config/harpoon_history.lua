local M = {}

local closed_items = {}

function M.compact(list)
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

function M.remove(list, index)
   local item = list:get(index)

   if not item then
      return false
   end

   closed_items[#closed_items + 1] = {
      index = index,
      item = item,
   }

   list:remove_at(index)
   M.compact(list)

   return true
end

function M.restore(list)
   local closed = table.remove(closed_items)

   if not closed then
      vim.notify("No closed Harpoon tabs", vim.log.levels.INFO)
      return false
   end

   list:add(closed.item)

   local _, current_index = list:get_by_value(closed.item.value)

   if not current_index then
      closed_items[#closed_items + 1] = closed
      return false
   end

   local displayed = {}

   for index = 1, list:length() do
      local item = list:get(index)

      if item then
         displayed[#displayed + 1] = list.config.display(item)
      end
   end

   local restored = table.remove(displayed, current_index)
   local target_index = math.min(closed.index, #displayed + 1)

   table.insert(displayed, target_index, restored)
   list:resolve_displayed(displayed, #displayed)
   list:select(target_index)

   return true
end

return M
