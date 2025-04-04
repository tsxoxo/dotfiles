--  See `:help vim.keymap.set()`

vim.g.mapleader=' '
-- Not sure what the difference is.
vim.g.maplocalleader = ' '

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Switch to file explorer
vim.keymap.set('n', '<leader>ee', vim.cmd.Ex, { desc = "Open file explorer" })

vim.keymap.set('n', '<leader>cd', function() vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h")) end, { desc = 'Set CWD to open file' })

-- Movement
vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz', { desc = 'Move down half a page while keeping cursor centered.' })

vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz', { desc = 'Move up half a page while keeping cursor centered.' })

vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Faster exit from insert mode' })

-- Delete without overwriting yank register
vim.keymap.set({'n', 'x'}, 'x', '"_x')
vim.keymap.set({'n', 'x'}, 'X', '"_d')

-- Save file
vim.keymap.set({ 'n', 'v' }, '<leader>ww', vim.cmd.write, { desc = 'Save file.' })

-- Show colorcolumn
-- TODO: Toggle this.
vim.keymap.set({ 'n', 'v' }, '<leader>gq', '<cmd>set colorcolumn=80<CR>', { desc = 'Show 80char column ruler.' })
-- vim.keymap.set({ 'n', 'v' }, '<leader>ww', vim.opt.colorcolumn = "79", { desc = 'Show 80char column ruler.' })

-- Execute code on the spot
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>', {desc = 'Execute/source whole file.'})
vim.keymap.set('n', '<leader>x', ':.lua<CR>', {desc = 'Execute line of Lua.'})
vim.keymap.set('v', '<leader>x', ':lua<CR>', {desc = 'Execute selected region of Lua.'})
