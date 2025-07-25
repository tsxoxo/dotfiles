--- DEBUG
-- vim.lsp.set_log_level("debug")
-- The log-file is at: vim.fn.stdpath("cache") .. "/lsp.log"
-- open it with command: :edit <C-r>=vim.lsp.get_log_path()<CR>
--:LspRestart (if you have it mapped, or lua vim.lsp.buf.restart_client()
--

vim.lsp.enable({
	"cssls",
	-- "emmet_ls",
	"vtsls",
	"vue_ls",
	"lua_ls",
	"bashls",
})

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- vim.opt.completeopt = { "menuone", "noselect", "popup" }

---------------------
--- Setup keymaps ---
---------------------
-- DEFAULT KEYMAPS as found in the docs: https://neovim.io/doc/user/lsp.html#_global-defaults
-- and more here: https://gpanders.com/blog/whats-new-in-neovim-0-11/#defaults
-- "grn" is mapped in Normal mode to vim.lsp.buf.rename()
-- "gra" is mapped in Normal and Visual mode to vim.lsp.buf.code_action()
-- "grr" is mapped in Normal mode to vim.lsp.buf.references()
-- "gri" is mapped in Normal mode to vim.lsp.buf.implementation()
-- "gO" is mapped in Normal mode to vim.lsp.buf.document_symbol()
-- CTRL-S is mapped in Insert mode to vim.lsp.buf.signature_help()
-- "an" and "in" are mapped in Visual mode to outer and inner incremental selections, respectively, using vim.lsp.buf.selection_range()

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client then
			if client:supports_method("textDocument/inlayHint") and vim.g.auto_inlay_hint then
				vim.lsp.inlay_hint.enable()
			end

			if client:supports_method("textDocument/declaration") then
				vim.keymap.set("n", "gD", function()
					vim.lsp.buf.declaration({ bufnr = args.buf })
				end)
			end

			if client:supports_method("textDocument/definition") then
				vim.keymap.set("n", "gd", function()
					vim.lsp.buf.definition({ buffer = args.buf })
				end)
			end

			-- -@see doc :h vim.lsp.document_color
			if client:supports_method("textDocument/documentColor") then
				if vim.lsp.document_color then
					vim.lsp.document_color.enable(true, args.buf, {
						style = "virtual",
					})
				end
			end

			-- Auto-completion
			-- if client:supports_method("textDocument/completion") then
			-- 	vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
			-- end
		end

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({
				border = "rounded",
				desc = "Show tooltip",
			})
		end, {
			buffer = args.buf,
			noremap = true,
		})

		vim.keymap.set("n", "<leader>d", function()
			vim.diagnostic.open_float({ bufnr = args.buf, border = "rounded" })
		end, {
			buffer = args.buf,
			noremap = true,
			desc = "Show line diagnostics",
		})

		vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", {
			buffer = args.buf,
			noremap = true,
			desc = "Show line diagnostics",
		})
	end,
})
