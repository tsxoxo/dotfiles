--  See `:help vim.keymap.set()`

vim.g.mapleader = " "
vim.g.maplocalleader = " "

------------
-- SYSTEM --
------------
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Make search use very magic by default
-- Because the default means I have to escape + but not *,
-- which is confusing.
vim.keymap.set("n", "/", "/\\v", { desc = "Search with very magic" })
vim.keymap.set("n", "?", "?\\v", { desc = "Reverse search with very magic" })

------------
-- [F]ile --
------------
vim.keymap.set({ "n", "v" }, "<leader>fw", vim.cmd.write, { desc = "Save file." })
vim.keymap.set({ "n", "v" }, "<leader>fq", "<cmd>qa<CR>", { desc = "Close all and quit (:qa)." })

vim.keymap.set("n", "<leader>fe", vim.cmd.Oil, { desc = "Open file explorer" })

-----------------------------
-- INTER-BUFFER NAVIGATION --
-----------------------------
vim.keymap.set({ "n", "v" }, "<leader><leader>", "<cmd>b#<CR>", { desc = "Switch to last bugger." })

-- Switch between a handful set buffers fast
local function switch_to_buffer_based_on_file_mark(mark_char)
	local buf_id = vim.api.nvim_get_mark(mark_char, {})[3]

	if buf_id > 0 and vim.api.nvim_buf_is_valid(buf_id) then
		vim.cmd("b" .. buf_id)
	else
		vim.notify("Mark '" .. mark_char .. "' not found or buffer invalid.", vim.log.levels.WARN)
	end
end

local function create_quick_slot(key)
	local _key = key
	vim.keymap.set({ "n", "v" }, "<leader>" .. _key, function()
		switch_to_buffer_based_on_file_mark(string.upper(_key))
	end, { desc = "Switch to slot U" .. _key })
end

create_quick_slot("u")
create_quick_slot("i")
create_quick_slot("o")
create_quick_slot("p")

-----------------------------
-- INTRA-BUFFER NAVIGATION --
-----------------------------
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Move down half a page while keeping cursor centered." })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Move up half a page while keeping cursor centered." })
vim.keymap.set("i", "<C-l>", "<Right> ", { desc = "Move cursor from between brackets." })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Leave insert mode" })

-------------------
-- YANK/PASTE... --
-------------------
-- don't overwrite yank register
vim.keymap.set({ "n", "x" }, "x", '"_x', { desc = "Delete char without yanking" })
vim.keymap.set({ "n", "x" }, "X", '"_d', { desc = "Delete text without yanking" })
vim.keymap.set({ "n", "x" }, "c", '"_c', { desc = "Change without yanking" })
-- For pasting over selection without overwriting yank reg: use 'P'
-- see :help v_P

-- when yanking selection, go to next line instead of jumping to the top
vim.keymap.set("x", "y", "y']", { desc = "Yank and move to bottom" })

-------------
-- TOGGLES --
-------------
-- Show vertical ruler
local function toggle_ruler(col)
	local _col = tostring(col)
	local current_ruler_position = vim.opt_local.colorcolumn:get()[1]

	if current_ruler_position == _col then
		vim.opt_local.colorcolumn = ""
	else
		vim.opt_local.colorcolumn = _col
	end
end

vim.keymap.set({ "n", "v" }, "<leader>t|", function()
	toggle_ruler(80)
end, { desc = "Show 80char column ruler." })

-- convert list item to todo and mark as DONE == add [x] to start of line
vim.keymap.set("n", "<leader>td", "^ciW- [x]<Esc>", { desc = "[x] DONE" })

--------------
-- QUICKFIX --
--------------
-- Defaults that come with Nvim 0.11: ]q, [q, ]Q, [Q
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Open quickfix" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { desc = "Close quickfix" })

vim.keymap.set("n", "<leader>qf", "<cmd>Telescope quickfix<CR>", { desc = "Telescope quickfix" })

-- Search current word and send results to quickfix
vim.keymap.set("n", "<leader>qs", function()
	vim.cmd("grep! " .. vim.fn.expand("<cword>"))
	vim.cmd("copen")
end, { desc = "Search word to quickfix" })

--------------
-- Snippets --
--------------
-- Em-Dash
vim.keymap.set("i", "--", "—", { desc = "Em dash" })

-- Borders to separate code sections
vim.keymap.set("n", "<leader>g#", "60i#<Esc>", { desc = "#####" })
vim.keymap.set("n", "<leader>g=", "60i=<Esc>", { desc = "=====" })
vim.keymap.set("n", "<leader>g-", "60i-<Esc>", { desc = "-----" })

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)

-- Lua
-- Execute code on the spot
vim.keymap.set("n", "<leader>cfx", "<cmd>source %<CR>", { desc = "Execute/source whole file." })
vim.keymap.set("n", "<leader>cx", ":.lua<CR>", { desc = "Execute line of Lua." })
vim.keymap.set("v", "<leader>cx", ":lua<CR>", { desc = "Execute selected region of Lua." })

-- Create framed heading like so:
-------------
-- Heading --
-------------
-- Usage:
-- Place cursor anywhere on like with a commented heading and press the keys.
vim.keymap.set("n", "<leader>gt", "A --" .. esc .. "yyPVr-yyjp", { desc = "Create framed heading" })

-- JS/TS
-- console.log macro, js log
vim.api.nvim_create_augroup("js", { clear = true })

-- Usage:
-- Select symbol to log, press "@l"
vim.api.nvim_create_autocmd("FileType", {
	group = "js",
	pattern = { "javascript", "typescript", "vue" },
	callback = function()
		vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa: ', " .. esc .. "pa)" .. esc)
	end,
})

-- Bash
-- log macro, bash log
vim.api.nvim_create_augroup("bash", { clear = true })

-- Usage:
-- Select symbol to log, press "@l"
vim.api.nvim_create_autocmd("FileType", {
	group = "bash",
	pattern = { "bash", "sh", "zsh" },
	callback = function()
		vim.fn.setreg("l", 'yoecho "' .. esc .. "pa: ${" .. esc .. 'pa}"' .. esc)
	end,
})

-- ASM
-- Formatting macro
vim.api.nvim_create_augroup("asm", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = "asm",
	pattern = { "asm" },
	callback = function()
		local tab = vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
		vim.fn.setreg("f", "0f;i " .. esc .. "diw" .. "i" .. tab .. esc)
	end,
})

-------------
--  DEBUG  --
-------------
---
--- Show info about diagnostic on current line (e.g. who produced it)

vim.keymap.set("n", "<leader>c?", function()
	print(vim.inspect(vim.diagnostic.get(0)))
end, { desc = "DEBUG: show info about diagnostic" })
