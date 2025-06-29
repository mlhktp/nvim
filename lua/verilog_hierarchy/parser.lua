-- Parses a Verilator *_final.tree.json plus its companion *.tree.meta.json
-- Returns: children_of, roots, modules  (all keyed by module addr)

local uv = vim.loop
local fn = vim.fn

local M = {}

-- helper: turn "k,15:8,15:15" → {file=filemap[k], filekey="k", start_line=15, start_col=8}
local function make_loc_parser(file_map)
  return function(loc_str)
    if type(loc_str) ~= "string" then return nil end
    local key, rest = loc_str:match("^([^,]+),(.*)$")
    if not key then return nil end
    local out = { filekey = key, file = file_map[key] }
    if rest then
      local sl, sc = rest:match("(%d+):(%d+)")
      out.start_line = sl and tonumber(sl) or nil
      out.start_col  = sc and tonumber(sc) or nil
    end
    return out
  end
end

---@param tree_path string path to *_final.tree.json
---@return table<string,{addr,inst,loc}[]> children_of
---@return string[] roots
---@return table<string,table> modules
function M.parse_file(tree_path)
  ---------------------------------------------------------------------------
  -- 1. Load *_final.tree.json ------------------------------------------------
  ---------------------------------------------------------------------------
  local ok, lines = pcall(fn.readfile, tree_path)
  if not ok then
    vim.notify("Verilog-hierarchy: cannot read "..tree_path, vim.log.levels.ERROR)
    return {}, {}, {}
  end
  local j = fn.json_decode(table.concat(lines, "\n"))
  if type(j) ~= "table" or type(j.modulesp) ~= "table" then
    vim.notify("Verilog-hierarchy: invalid JSON in "..tree_path, vim.log.levels.ERROR)
    return {}, {}, {}
  end

  ---------------------------------------------------------------------------
  -- 2. Find a companion *.tree.meta.json ------------------------------------
  ---------------------------------------------------------------------------
  local meta_path = tree_path:gsub("%.tree%.json$", ".tree.meta.json")
  if not uv.fs_stat(meta_path) then
    -- fall back: pick *any* .tree.meta.json in the same dir
    local dir = fn.fnamemodify(tree_path, ":h")
    local metas = fn.glob(dir.."/*.tree.meta.json", false, true)
    if #metas > 0 then meta_path = metas[1] end
  end

  ---------------------------------------------------------------------------
  -- 3. Load meta → file_map --------------------------------------------------
  ---------------------------------------------------------------------------
  local file_map = {}
  if uv.fs_stat(meta_path) then
    local ok2, ml = pcall(fn.readfile, meta_path)
    if ok2 then
      local meta = fn.json_decode(table.concat(ml, "\n")) or {}
      if type(meta.files) == "table" then
        for key, info in pairs(meta.files) do
          if type(info) == "table" and info.realpath then
            file_map[key] = info.realpath
          end
        end
      end
    end
  end

  local parse_loc = make_loc_parser(file_map)

  ---------------------------------------------------------------------------
  -- 4. Build module map (addr → module) and attach loc ----------------------
  ---------------------------------------------------------------------------
  local modules = {}
  for _, m in ipairs(j.modulesp) do
    if m.type == "MODULE" then
      m.loc = parse_loc(m.loc)
      modules[m.addr] = m
    end
  end

  ---------------------------------------------------------------------------
  -- 5. Walk statements → children_of ----------------------------------------
  ---------------------------------------------------------------------------
  local children_of, referenced = {}, {}

  local function add_child(parent, child_addr, inst_name, raw_loc)
    children_of[parent] = children_of[parent] or {}
    for _, v in ipairs(children_of[parent]) do
      if v.addr == child_addr and v.inst == inst_name then return end
    end
    table.insert(children_of[parent], {
      addr = child_addr,
      inst = inst_name,
      loc  = parse_loc(raw_loc),
    })
    referenced[child_addr] = true
  end

  local function walk(parent_addr, stmts, prefix)
    for _, s in ipairs(stmts) do
      if s.type == "CELL" and s.modp and modules[s.modp] then
        local inst = prefix and (prefix.."."..s.name) or s.name
        add_child(parent_addr, s.modp, inst, s.loc)
      end
      if type(s.stmtsp) == "table" then
        local np = prefix
        if s.type == "BEGIN" and s.name then
          np = prefix and (prefix.."."..s.name) or s.name
        end
        walk(parent_addr, s.stmtsp, np)
      end
      if type(s.exprsp) == "table" then
        for _, e in ipairs(s.exprsp) do
          if type(e.stmtsp) == "table" then
            walk(parent_addr, e.stmtsp, prefix)
          end
        end
      end
    end
  end

  for addr, mod in pairs(modules) do
    if type(mod.stmtsp) == "table" then
      walk(addr, mod.stmtsp, nil)
    end
  end

  ---------------------------------------------------------------------------
  -- 6. Roots = modules never referenced -------------------------------------
  ---------------------------------------------------------------------------
  local roots = {}
  for addr in pairs(modules) do
    if not referenced[addr] then table.insert(roots, addr) end
  end
  table.sort(roots)

  return children_of, roots, modules
end

return M
