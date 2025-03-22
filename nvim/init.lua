vim.keymap.set({ 'n', 'v' }, '<C-d>', '<C-d>zz', { desc = 'Move down half a page while keeping cursor centered.' })
vim.keymap.set({ 'n', 'v' }, '<C-u>', '<C-u>zz', { desc = 'Move up half a page while keeping cursor centered.' })

vim.keymap.set('i', 'jj', '<Esc>', { desc = 'Faster exit from insert mode' })

vim.keymap.set({ 'n', 'v' }, '<leader>ww', vim.cmd.write, { desc = 'Save file.' })

vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':lua<CR>')

-- Options
--
-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true
