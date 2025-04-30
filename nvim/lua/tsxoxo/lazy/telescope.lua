return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		-- Enable telescope for neovim core stuff
		-- (set vim.ui.select to telescope)
		{ "nvim-telescope/telescope-ui-select.nvim" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},

	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		-- local trouble = require("trouble")
		-- local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		-- local custom_actions = transform_mod({
		-- 	open_trouble_qflist = function(prompt_bufnr)
		-- 		trouble.toggle("quickfix")
		-- 	end,
		-- })

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					n = {
						-- this does not work universally,
						-- e.g. if i am browsing my quickfix list it also attempts to delete a buffer
						-- more useful would be 'delete item from list'
						-- ["<c-d>"] = require("telescope.actions").delete_buffer,
					},
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						-- ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						-- smart == send all if no selection OR selection
						-- ["<C-q>"] = actions.smart_send_to_qflist + custom_actions.open_trouble_qflist,
						-- ["<C-t>"] = trouble_telescope.open,
						["<C-h>"] = "which_key",
						["<c-d>"] = require("telescope.actions").delete_buffer,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		-- Alt syntax for fun
		local builtin = require("telescope.builtin")
		keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
		keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Telescope git files" })
		keymap.set("n", "<leader>fc", builtin.commands, { desc = "Telescope commands" })
		keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Telescope keymaps" })
	end,
}
