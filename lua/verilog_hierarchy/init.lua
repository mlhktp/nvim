-- lua/verilog_hierarchy/init.lua
-- Neo-tree external source showing a Verilator hierarchy with real file stats

local renderer = require("neo-tree.ui.renderer")
local utils    = require("neo-tree.utils")
local manager  = require("neo-tree.sources.manager")
local events   = require("neo-tree.events")
local uv       = vim.loop

local parser   = require("verilog_hierarchy.parser")

-------------------------------------------------------------------------------
-- Source descriptor ----------------------------------------------------------
-------------------------------------------------------------------------------
local M        = {
   name         = "verilog_hierarchy",
   display_name = "󰍛 Verilog",
   loc_map      = {}, -- populated each navigate()
}

-------------------------------------------------------------------------------
-- Config ---------------------------------------------------------------------
-------------------------------------------------------------------------------
local cfg      = {
   obj_dir        = "obj_dir",
   file_pattern   = "*_final.tree.json",
   show_addresses = false,
}

-------------------------------------------------------------------------------
-- Real stat provider (fixes Details panel) -----------------------------------
-------------------------------------------------------------------------------
-- Neo-tree passes the *node* table here – not a plain path string.
-- We pull node.path if it exists, call luv's fs_stat, and clamp defaults.
local function verilog_stat(node_or_path)
   -- 1) figure out the path
   local path = type(node_or_path) == "table"
       and node_or_path.path
       or node_or_path

   if not path or path == "" then
      return { size = 0, mtime = { sec = 0 }, birthtime = { sec = 0 } }
   end

   -- 2) stat the file
   local st = uv.fs_stat(path)
   if not st then
      -- file missing (maybe generated later) -> return zeros
      return { size = 0, mtime = { sec = 0 }, birthtime = { sec = 0 } }
   end

   -- 3) convert luv’s struct into Neo-tree’s expected shape
   local mtime_sec     = st.mtime and st.mtime.sec or 0
   local birthtime_sec = st.birthtime and st.birthtime.sec or mtime_sec

   return {
      size      = st.size or 0,
      mtime     = { sec = mtime_sec },
      birthtime = { sec = birthtime_sec },
   }
end

-- register (keep the same statutory name)
utils.register_stat_provider("verilog-stat", verilog_stat)

-------------------------------------------------------------------------------
-- Helpers --------------------------------------------------------------------
-------------------------------------------------------------------------------
local function glob(pats)
   if type(pats) == "string" then pats = { pats } end
   local out = {}
   for _, p in ipairs(pats) do
      for _, f in ipairs(vim.fn.glob(p, false, true)) do
         out[#out + 1] = f
      end
   end
   return out
end

local function load_hierarchy()
   local dir  = vim.fn.expand(cfg.obj_dir)
   local pats = (type(cfg.file_pattern) == "table") and cfg.file_pattern
       or { cfg.file_pattern }
   for i, p in ipairs(pats) do pats[i] = dir .. "/" .. p end
   local files = glob(pats)
   if #files == 0 then
      vim.notify("Verilog-hierarchy: no JSON in " .. dir, vim.log.levels.WARN)
      return {}, {}, {}
   end
   return parser.parse_file(files[1])
end

-------------------------------------------------------------------------------
-- setup() --------------------------------------------------------------------
-------------------------------------------------------------------------------
M.setup = function(user_cfg, _)
   cfg = vim.tbl_deep_extend("force", cfg, user_cfg or {})
   if uv.fs_stat(cfg.obj_dir) then
      manager.subscribe(M.name, {
         event   = events.FS_EVENT,
         pattern = cfg.obj_dir .. "/*.tree.json",
         handler = function() manager.refresh(M.name) end,
      })
   end
end

-------------------------------------------------------------------------------
-- Build nodes ----------------------------------------------------------------
-------------------------------------------------------------------------------
local function build_node(children_of, modules, addr, inst, parent_id, inst_loc)
   local mod      = modules[addr] or {}
   local seg      = mod.name or addr
   local id       = parent_id and (parent_id .. "/" .. inst) or inst
   local kids     = children_of[addr] or {}

   ---------------------------------------------------------------------------
   -- Decide which file represents this node (for stat + later actions)
   ---------------------------------------------------------------------------
   local rep_loc  = mod.loc or inst_loc or {}
   local rep_file = rep_loc.file

   local display  = string.format("%s: %s", inst, mod.origName or seg)
   if cfg.show_addresses and mod.loc and mod.loc.filekey then
      display = display .. " [" .. mod.loc.filekey .. "]"
   end

   local node = {
      id            = id,
      name          = display,
      type          = (#kids > 0) and "directory" or "file",
      path          = rep_file or "", -- Neo-tree passes this to our stat fn
      stat_provider = "verilog-stat",

      mod_loc       = mod.loc,
      inst_loc      = inst_loc,
   }

   if #kids > 0 then
      node.children = vim.tbl_map(function(c)
         return build_node(children_of, modules, c.addr, c.inst, id, c.loc)
      end, kids)
   end

   return node
end

-------------------------------------------------------------------------------
-- navigate() -----------------------------------------------------------------
-------------------------------------------------------------------------------
---@param state table
---@param _ string  (unused cwd param)
M.navigate = function(state, _)
   local children_of, roots, modules = load_hierarchy()

   -- 1) build the tree
   local items = vim.tbl_map(function(root_addr)
      local seg = (modules[root_addr] and modules[root_addr].name) or root_addr
      return build_node(children_of, modules, root_addr, "u_" .. seg, nil, nil)
   end, roots)

   -- 2) rebuild global loc_map
   M.loc_map = {}
   local function harvest(n)
      M.loc_map[n.id] = { mod_loc = n.mod_loc, inst_loc = n.inst_loc }
      if n.children then for _, c in ipairs(n.children) do harvest(c) end end
   end
   for _, r in ipairs(items) do harvest(r) end

   -- 3) show
   renderer.show_nodes(items, state)
end

-------------------------------------------------------------------------------
-- Commands, key-maps, components --------------------------------------------
-------------------------------------------------------------------------------
M.commands = require("verilog_hierarchy.commands")
M.keymaps  = {
   ["<C-CR>"]        = "open_module",   -- Ctrl-Enter
   ["<2-LeftMouse>"] = "open_module",   -- double-click
   ["<S-CR>"]        = "open_instance", -- Shift-Enter
}


-- plug the new components (icon / size / mtime)
M.components = require("verilog_hierarchy.components")

-- M.renderers = require("verilog_hierarchy.renderers")


return M
