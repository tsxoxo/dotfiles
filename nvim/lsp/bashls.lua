-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/bashls.lua
-- https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts

local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/"

return {
	cmd = { "bash-language-server", "start" },
	filetypes = { "bash", "sh" },
	settings = {
		bashIde = {
			-- Glob pattern for finding and parsing shell script files in the workspace.
			-- Used by the background analysis features across files.

			-- Prevent recursive scanning which will cause issues when opening a file
			-- directly in the home directory (e.g. ~/foo.sh).
			--
			-- Default upstream pattern is "**/*@(.sh|.inc|.bash|.command)".
			globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
			-- shellcheckPath = mason_bin_path .. "shellcheck",
			shfmt = {
				path = mason_bin_path .. "shfmt",
			},
		},
	},
	root_markers = { ".git" },
}
