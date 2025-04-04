require('tsxoxo/set')
require('tsxoxo/remap')
require('tsxoxo/lazy_init')


-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
--
-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.fn.stdpath("config") .. "/lua/tsxoxo/lazy/*.lua",
  callback = function()
    vim.cmd("silent! Lazy sync")
  end,
})


-- DEBUG
-- Parts of my config like keybinds and certain behaviors
-- get unloaded after a while after starting nvim.
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  callback = function(args)
    vim.notify("Lazy loaded: " .. vim.inspect(args.data), vim.log.levels.INFO)
  end,
})
