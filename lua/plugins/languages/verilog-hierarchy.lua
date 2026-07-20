return {
  "mlhktp/verilog-hierarchy.nvim",
  dependencies = {
    { "nvim-neo-tree/neo-tree.nvim", branch = "v3.x" },
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
  },
  cmd = "VerilogHierarchy",
  config = function()
    require("neo-tree").setup({
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "verilog-hierarchy",
      },
      ["verilog-hierarchy"] = {
        obj_dir = "obj_dir",
        file_pattern = "*_final.tree.json",
        show_addresses = false,
      },
    })
  end,
}
