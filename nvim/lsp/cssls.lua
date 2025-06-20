--- https://github.com/hrsh7th/vscode-langservers-extracted
---
--- Neovim does not currently include built-in snippets. `vscode-css-language-server` only provides completions when snippet support is enabled. To enable completion, install a snippet plugin and add the following override to your language client capabilities during setup.
---
--- ```lua
--- --Enable (broadcasting) snippet capability for completion
--- local capabilities = vim.lsp.protocol.make_client_capabilities()
--- capabilities.textDocument.completion.completionItem.snippetSupport = true
---
--- vim.lsp.config('cssls', {
---   capabilities = capabilities,
--- })
--- ```
---
--- Gemini suggests doing the following to enable completion:
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Enable snippet support
-- You might be using a completion plugin (like nvim-cmp)
-- which often provides a helper to update capabilities.
-- For example, if you're using cmp-nvim-lsp:
-- local cmp_nvim_lsp = require('cmp_nvim_lsp')
-- capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
-- If not using such a plugin, the line below is sufficient for native LSP.
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
--
-- and then add capabilities = capabilities to the returned table below

return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	init_options = { provideFormatter = true }, -- needed to enable formatting capabilities
	root_markers = { "package.json", ".git" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}
