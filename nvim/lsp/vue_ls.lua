---@brief
---
-- https://github.com/vuejs/language-tools/wiki/Neovim
--
-- The setup for vue_ls and vtsls is copied verbatim from:
-- https://github.com/bearguns/vue_ls_v3_nvim/tree/main
-- as found in the following thread from Discord server Vueland:
-- https://discord.com/channels/325477692906536972/1382376021264830494

return {
	cmd = { "vue-language-server", "--stdio" },
	filetypes = { "vue" },
	on_init = function(client)
		client.handlers["tsserver/request"] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
			if #clients == 0 then
				vim.notify(
					"Could not found `vtsls` lsp client, vue_lsp would not work without it.",
					vim.log.levels.ERROR
				)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = "typescript server request",
				command = "typescript.tsserverRequest",
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r.body } }
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify("tsserver/response", response_data)
			end)
		end
	end,
}
