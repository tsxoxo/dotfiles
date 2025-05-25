require("tsxoxo/set")
require("tsxoxo/remap")
require("tsxoxo/lazy_init")

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Make :help open in a vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function()
		-- Get buffer handle
		local buf = vim.api.nvim_get_current_buf()

		-- Check if we're in a regular help window
		if vim.bo[buf].buftype == "help" then
			-- Convert to vertical split
			vim.cmd.wincmd("L")

			-- Optional: set reasonable width
			vim.cmd("vertical resize 80")
		end
	end,
})

-- cd into dir 'foo' when opening via 'nvim foo'
vim.api.nvim_create_autocmd("TextChanged", {
	desc = "Set cwd to follow directory shown in oil buffers.",
	group = vim.api.nvim_create_augroup("OilAutoCwd", {}),
	pattern = "oil:///*",
	callback = function()
		if vim.bo.filetype == "oil" then
			vim.cmd.lcd(require("oil").get_current_dir())
		end
	end,
})

-- Highlight when yanking (copying) text
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Detect shell scripts without extensions by shebang
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Detect shell scripts without extensions by shebang",
	pattern = "*",
	callback = function()
		local first_line = vim.fn.getline(1)
		if string.match(first_line, "^#!.*/bin/bash") or string.match(first_line, "^#!.*/bin/env%s+bash") then
			vim.cmd("setfiletype bash")
		end
	end,
})

-- .asm files in /fasm are fasm
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "*/APPS/*.asm",
	callback = function()
		vim.cmd("setfiletype fasm")
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
