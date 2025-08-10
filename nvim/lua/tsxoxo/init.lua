require("tsxoxo/set")
require("tsxoxo/remap")
require("tsxoxo/lazy_init")
require("tsxoxo/lsp-setup")

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

-- Formatting for asm
-- thanks, Claude
vim.api.nvim_create_autocmd("FileType", {
	pattern = "asm",
	callback = function()
		vim.opt_local.expandtab = false
		vim.opt_local.tabstop = 64
		-- does not work well with >8
		vim.opt_local.shiftwidth = 16
		vim.opt_local.softtabstop = 0
		-- Smart tab for assembly: indent to 16, then comments to 64
		vim.keymap.set("i", "<Tab>", function()
			local col = vim.fn.col(".")

			if col <= 8 then
				-- Indent subroutines: go to column 16
				local spaces_needed = 8 - col
				return string.rep(" ", spaces_needed + 1) -- +1 because col() is 1-based
			else
				-- TODO: do this with tabs
				-- Comment alignment: go to column 64
				local spaces_needed = 64 - col
				if spaces_needed > 0 then
					return string.rep(" ", spaces_needed + 1)
				else
					return " " -- Already past 64, just add a space
				end
			end
		end, { expr = true, buffer = true, desc = "ASM smart tab: indent to 16, comments to 64" })
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

-- Auto-format markdown
-- NOTE: used it for 3 days. Had some undesired behavior (collapsing spaces, joining lines)
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	desc = "Add [a]uto-format to formatting-options",
-- 	pattern = "markdown",
-- 	callback = function()
-- 		print("format")
-- 		vim.opt_local.formatoptions:append("a")
-- 	end,
-- })
--
-- .asm files in /fasm are fasm
-- vim.api.nvim_create_autocmd("BufReadPost", {
-- 	pattern = "*/APPS/*.asm",
-- 	callback = function()
-- 		-- 'asm' works better than 'fasm': e.g. allows for comments
-- 		vim.cmd("setfiletype asm")
-- 	end,
-- })

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = vim.fn.stdpath("config") .. "/lua/tsxoxo/lazy/*.lua",
-- 	callback = function()
-- 		vim.cmd("silent! Lazy sync")
-- 	end,
-- })

-- DEBUG
-- Parts of my config like keybinds and certain behaviors
-- get unloaded after a while after starting nvim.
-- vim.api.nvim_create_autocmd("User", {
-- 	pattern = "LazyLoad",
-- 	callback = function(args)
-- 		vim.notify("Lazy loaded: " .. vim.inspect(args.data), vim.log.levels.INFO)
-- 	end,
-- })
