# My Neovim Config

## Cheatsheet

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

## Keybindings

### Categories

#### Workspace

- key candidates: w, s, p

- see all errors, ( search all files? )

#### Search

- key candidates: s, f

#### Git

#### LSP

- key candidates: l, g

### I've wanted

#### LSP

- View errors/warnings for whole file. Go to A. Fix it. Go to B. -- would involve quickfix list, and mb telescope
- View errors/warnings for line (extend cut off text) -- **<leader>d**

- Go to definition -- **gd**
- Go to type reference. Go to next.

- Rename symbol

#### Text manipulation

- Delete into void; paste without yanking

## "Inspiration"

- Primeagen
- Josean
