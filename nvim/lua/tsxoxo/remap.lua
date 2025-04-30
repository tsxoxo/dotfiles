--  See `:help vim.keymap.set()`

vim.g.mapleader = " "
-- Not sure what the difference is.
vim.g.maplocalleader = " "

-- TODO:
-- 2025-04-24
--* group bindings
-- [ ] jump to next/previous
--* copy telescope bindings from kickstart

-- SYSTEM
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- SAVING AND QUITTING
vim.keymap.set({ "n", "v" }, "<leader>fw", vim.cmd.write, { desc = "Save file." })
-- vim.keymap.set({ 'n', 'v' }, '<leader><leader>wa', vim.cmd('wa'), { desc = 'Save all.' })

vim.keymap.set({ "n", "v" }, "<leader>fq", "<cmd>qa<CR>", { desc = "Close all and quit (:qa)." })

vim.keymap.set({ "n", "v" }, "<leader>fo", "<cmd>Obsess<CR>", { desc = "Obsess (start vim session)" })

-- INTER-BUFFER
vim.keymap.set("n", "<leader>fe", vim.cmd.Oil, { desc = "Open file explorer" })
-- vim.keymap.set('n', '<leader>ee', vim.cmd.Ex, { desc = "Open file explorer" })

vim.keymap.set({ "n", "v" }, "<leader><leader>", "<cmd>b#<CR>", { desc = "Switch to last bugger." })

vim.keymap.set("n", "<leader>fcd", function()
	vim.api.nvim_set_current_dir(vim.fn.expand("%:p:h"))
end, { desc = "Set CWD to open file" })

vim.keymap.set("n", "<leader>fd", "<cmd>bd<CR>", { desc = "Delete current buffer" })

-- INTRA-BUFFER
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Move down half a page while keeping cursor centered." })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Move up half a page while keeping cursor centered." })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Leave insert mode" })

-- vim movement
-- vim.keymap.set({ "n", "v" }, "<C-y>", "_", { desc = "to start of line" })
-- vim.keymap.set({ "n", "v" }, "<C-o>", "$", { desc = "to end of line" })
-- vim.keymap.set({ "n", "v" }, "<C-i>", "<C-u>zz", { desc = "to start of file" })
-- vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "to end of file" })

-- Diagnostics
-- see also trouble.lua
-- vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Delete without overwriting yank register
vim.keymap.set({ "n", "x" }, "x", '"_x')
vim.keymap.set({ "n", "x" }, "X", '"_d')

-- Execute code on the spot
vim.keymap.set("n", "<leader>fx", "<cmd>source %<CR>", { desc = "Execute/source whole file." })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Execute line of Lua." })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Execute selected region of Lua." })

-- Show colorcolumn
-- TODO: Toggle this.
vim.keymap.set({ "n", "v" }, "<leader>gq", "<cmd>set colorcolumn=80<CR>", { desc = "Show 80char column ruler." })
-- vim.keymap.set({ 'n', 'v' }, '<leader>ww', vim.opt.colorcolumn = "79", { desc = 'Show 80char column ruler.' })

-- Quickfix
-- vim.keymap.set("n", "]q", "<cmd>Trouble quickfix next focus=false<CR>", { desc = "next quickfix item" })
-- vim.keymap.set("n", "]q", function()
-- 	require("trouble").next({ mode = "quickfix", jump = true, focus = false })
-- end, { silent = true, desc = "Next Trouble qf item (no focus change)" })
--
-- vim.keymap.set("n", "[q", "<cmd>Trouble quickfix prev focus=false<CR>", { desc = "previous quickfix item" })
-- vim.keymap.set("n", "]Q", "<cmd>Trouble quickfix last focus=false<CR>", { desc = "Last quickfix item" })
-- vim.keymap.set("n", "[Q", "<cmd>Trouble quickfix first focus=false<CR>", { desc = "First quickfix item" })

vim.keymap.set("n", "<leader>qf", "<cmd>Telescope quickfix<CR>", { desc = "Browse quickfix" })
vim.keymap.set("n", "<leader>qs", function()
	-- Search current word and send results to quickfix
	vim.cmd("grep! " .. vim.fn.expand("<cword>"))
	vim.cmd("copen")
end, { desc = "Search word to quickfix" })
