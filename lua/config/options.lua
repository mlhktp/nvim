local opt = vim.opt -- for conciseness

-- General
opt.linebreak = false
opt.whichwrap = "b,s" -- basic default value

-- line numbers
opt.relativenumber = true -- show relative line numbers
opt.number = true -- shows absolute line number on cursor line (when relative number is on)

-- tabs & indentation
opt.tabstop = 3 -- display width of a tab
opt.shiftwidth = 3 -- spaces used for each indentation level
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- line wrapping
opt.wrap = true -- enable line wrapping

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- cursor line
opt.cursorline = true -- highlight the current cursor line

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift
opt.fillchars:append({ eob = " " }) -- hide ~ lines after the end of the buffer

-- Keep the number and sign columns transparent across colorscheme changes.
vim.api.nvim_create_autocmd("ColorScheme", {
   callback = function()
      local groups = {
         "LineNr",
         "CursorLineNr",
         "LineNrAbove",
         "LineNrBelow",
         "SignColumn",
         "CursorLineSign",
         "GitSignsAdd",
         "GitSignsChange",
         "GitSignsDelete",
         "GitSignsTopdelete",
         "GitSignsChangedelete",
         "GitSignsUntracked",
      }

      for _, group in ipairs(groups) do
         local highlight = vim.api.nvim_get_hl(0, { name = group, link = false })
         highlight.bg = nil
         vim.api.nvim_set_hl(0, group, highlight)
      end
   end,
})



-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- fix bug with lualine
opt.laststatus = 3

opt.title = true
opt.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " |  "

-- Visualize whitespace
-- opt.list = true
-- opt.listchars:append("space:·")

-- VimTeX config
vim.g.vimtex_view_method = "zathura"

-- Diagnostics: don't globally disable them here.
-- Let `zen-mode` or toggle commands manage that.
-- Leave this commented unless intentional:
-- vim.diagnostic.enable(false)
vim.opt.cursorline = false

if vim.env.NVIM_RANGER == "1" then
   vim.opt.number = false
   vim.opt.relativenumber = false
   vim.opt.cursorline = false
   vim.opt.laststatus = 0
   vim.opt.showtabline = 0
end
