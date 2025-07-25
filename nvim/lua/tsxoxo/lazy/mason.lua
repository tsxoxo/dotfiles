return {
	"mason-org/mason.nvim",
	dependencies = {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"mason-org/mason-lspconfig.nvim",
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

		-- mason-lspconfig is only here to make sure Mason installs these.
		-- All setup is done via the individual LSP config files in nvim/lsp
		mason_lspconfig.setup({
			ensure_installed = {
				"html",
				"emmet_ls",
				"cssls",
				"tailwindcss",
				"ts_ls",
				"vtsls",
				"vue_ls@3.0.0-alpha.10",
				"lua_ls",
				"bashls",
				"asm_lsp",
			},
			automatic_enable = false,
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
