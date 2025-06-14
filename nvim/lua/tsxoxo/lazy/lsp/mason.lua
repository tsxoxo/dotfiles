return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			opts = {
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"html",
				"emmet_ls",
				"cssls",
				"tailwindcss",
				"ts_ls", -- TS support in Vue files.
				"volar",
				"lua_ls",
				"bashls",
				"asm_lsp",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				-- DAPs (Debug)
				"bash-debug-adapter",
				-- Linters
				"shellcheck",
				"eslint_d",
				-- Formatters
				"prettier",
				"stylua",
				"shfmt",
				-- Extra LSPs
			},
		})
	end,
}
