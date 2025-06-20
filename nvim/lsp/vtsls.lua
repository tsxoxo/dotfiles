-- https://github.com/yioneko/vtsls
-- https://github.com/neovim/nvim-lspconfig/blob/master/lsp/vtsls.lua
--------------------------------------------------------------------------------
--- Configured as per here:
--- https://github.com/vuejs/language-tools/wiki/Neovim
--------------------------------------------------------------------------------

local vue_language_server_path = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")
local vue_plugin = {
	name = "@vue/typescript-plugin",
	location = vue_language_server_path,
	languages = { "vue" },
	configNamespace = "typescript",
}

return {
	cmd = { "vtsls", "--stdio" },
	init_options = {
		plugins = {
			vue_plugin,
		},
	},
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
		"vue",
	},
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
}
