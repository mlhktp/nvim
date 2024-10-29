require "nvchad.options"

-- indentation is and tab and indent width is 3
-- vim.opt.tabstop = 3
-- vim.opt.shiftwidth = 3
-- vim.opt.expandtab = true


-- add yours here!
-- vim.opt.cmdheight = 1
--
-- vim.api.nvim_create_autocmd('CmdlineEnter', {
--     group = vim.api.nvim_create_augroup(
--         'cmdheight_1_on_cmdlineenter',
--         { clear = true }
--     ),
--     desc = 'Don\'t hide the status line when typing a command',
--     command = ':set cmdheight=1',
-- })
--
-- vim.api.nvim_create_autocmd('CmdlineLeave', {
--     group = vim.api.nvim_create_augroup(
--         'cmdheight_0_on_cmdlineleave',
--         { clear = true }
--     ),
--     desc = 'Hide cmdline when not typing a command',
--     command = ':set cmdheight=0',
-- })
--
-- vim.api.nvim_create_autocmd('BufWritePost', {
--     group = vim.api.nvim_create_augroup(
--         'hide_message_after_write',
--         { clear = true }
--     ),
--     desc = 'Get rid of message after writing a file',
--     pattern = { '*' },
--     command = 'redrawstatus',
-- })
local o = vim.o
o.shiftwidth = 3
o.softtabstop = 3
o.smartindent = true
o.tabstop = 3
o.expandtab = true
-- o.cursorlineopt ='both' -- to enable cursorline!
