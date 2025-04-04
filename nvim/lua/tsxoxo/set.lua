-- SYSTEM
--
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Enable break indent
-- try this out
-- vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 250

-- TODO: omg it still does not work
-- Don't show 'press ENTER'
-- Other syntax
-- vim.opt.shortmess = {
--   o = true
-- }
vim.opt.shortmess:append("aoOstTIcF")

vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- BEHAVIOR
--
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Open files in netrw file browser without extra confirmation
vim.g.netrw_fastbrowse = 0
-- vim.opt.netrw_fastbrowse = true
vim.g.netrw_banner = 0
vim.g.netrw_silent = 1
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 8

-- UI
--
-- Show absolute line number on current line
vim.opt.number = true

-- Show relative line numbers for other lines
vim.opt.relativenumber = true

-- Highlight the current cursor line for better visibility
vim.opt.cursorline = true

-- Use a single global status line at the bottom of the editor
vim.opt.laststatus = 3

-- Hide command line when not in use for a cleaner interface
-- This causes the PRESS ENTER messages so disable for now
vim.opt.cmdheight = 1
-- Set width of the line number column to 4 characters
vim.opt.numberwidth = 4
-- Always show the sign column for git indicators and diagnostics
vim.opt.signcolumn = "yes"

-- Don't show the mode, since it's already in the status line
-- try this out sometimes
-- vim.opt.showmode = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- More colors? Not sure
vim.opt.termguicolors = true

-- INDENTATION
--
-- Enable smart auto-indentation based on code syntax
vim.opt.smartindent = true

-- Convert tabs to spaces for consistent indentation
vim.opt.expandtab = true

-- Set tab width to 4 spaces
vim.opt.tabstop = 4

-- Set indentation level to 4 spaces
vim.opt.shiftwidth = 2

