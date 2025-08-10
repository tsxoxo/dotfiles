# My Neovim Config

## Cheatsheet

### Reload config file

`:so %`

### Jumping

see full list at ":help ']" and after

gi jump to last edit and switch to insert mode
`.	jump to position where last change occurred in current buffer
`" jump to position where last exited current buffer
`0	jump to position in last file edited (when exited Vim)
`1 like `0 but the previous file (also `2 etc)
'' jump back (to line in current buffer where jumped from)
``	jump back (to position in current buffer where jumped from)
`[ or `] jump to beginning/end of previously changed or yanked text
`< or `> jump to beginning/end of last visual selection

### Repeat '#' n times

- `69i#<Esc>`
- `:put =string.rep('=', 80)`

### Save as...

:w new_filename.asm " Write copy to new file, keep editing original
:saveas new_filename " Write copy to new file, and switch to it
:saveas! new_filename " Force overwrite if file exists

### Copy from command line

<C-f> " In command mode: open command history window
q: " From normal mode: open command history window

### Get CWD of current buffer

-- Get directory of current buffer
vim.fn.expand('%:p:h')

-- Alternative using vim.api
local bufname = vim.api.nvim_buf_get_name(0)
local dir = vim.fn.fnamemodify(bufname, ':p:h')

-- Using vim.fs (Neovim 0.8+)
local bufname = vim.api.nvim_buf_get_name(0)
local dir = vim.fs.dirname(bufname)

### Get nvim sys dir

`:lua print(vim.fn.stdpath("config"))`

### Print lua table

Two methods:

1. Use `vim.inspect`: `:lua print(vim.inspect(vim.api.nvim_get_mark('U',{})))`
2. `:lua = vim.api.some_func()`

### Explore keymaps

-- Find out where a keymap is set: `:verbose map`
-- Find info about specific keymap: `verbose nmap ]a`

### Lua API basics

vim.cmd, vim.api, vim.fn, and vim.opt/opt_local/opt_window

NB: remember your friends: `:help vim.opt`, `:help lua-guide-options`

#### Examples

**vim.cmd**
Executes vim command foo via lua
`vim.cmd("foo")`

**vim.fn**
Runs vim function
`local current_file_path = vim.fn.expand('%:p')`

**vim.opt**
vim.opt.tabstop = 4 -- Global option
vim.opt.shiftwidth = 4 -- Global option
vim.opt.expandtab = true -- Global option
vim.opt.relativenumber = true -- Global relative line numbers

-- In an autocommand for Python files:
vim.api.nvim_create_autocmd('FileType', {
pattern = 'python',
callback = function()
vim.opt_local.tabstop = 4 -- Buffer-local for Python
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.list = true -- Show whitespace characters
end
})

**vim.api**
Interact with Neovim's core state (buffers, windows, options, keymaps, etc.)

Get buffer id from a file-mark:
`local buf_id = vim.api.nvim_get_mark(mark_char, {})[3]`

## DEBUG

- formatting: `:ConformInfo`
- LSP: `:checkhealth lsp` or `checkhealth vim.lsp`

## Keybindings

### Code

- View errors/warnings for whole file -- **<leader>D**

- put a bunch of stuff in quickfix list, move to next item: run telescope, `C-q` for all OR `<tab>...` and then `M-Q` for selection, `]q`

- View errors/warnings for line (extend cut off text) -- **<leader>d**

- Go to definition -- **gd**

- Rename symbol -- **grn**

## Feature wishlist

- see all errors/diagnostics in project

## Inspiration

- Primeagen
- Josean
