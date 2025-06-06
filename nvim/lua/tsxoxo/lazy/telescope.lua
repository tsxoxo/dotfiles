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
						-- attempt for a keybinding to delete a buffer.
						-- this does not work universally,
						-- e.g. if i am browsing my quickfix list it also attempts to delete a buffer
						-- more useful would be 'delete item from list'
						-- ["<c-d>"] = require("telescope.actions").delete_buffer,
						["<C-y>"] = actions.cycle_history_next,
						["<C-z>"] = actions.cycle_history_prev,
					},
					i = {
						-- ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						-- smart == send all if no selection OR selection
						-- ["<C-q>"] = actions.smart_send_to_qflist + custom_actions.open_trouble_qflist,
						-- ["<C-t>"] = trouble_telescope.open,
						["<C-h>"] = "which_key",
						["<c-d>"] = require("telescope.actions").delete_buffer,
						["<C-y>"] = actions.cycle_history_next,
						["<C-z>"] = actions.cycle_history_prev,
					},
				},
			},
			pickers = {
				find_files = {
					-- hidden = true,
					-- can't be that simple as this breaks when running telescope from an oil/file explorer buffer
					-- cwd = require("telescope.utils").buffer_dir(),
					-- cwd = vim.fn.expand("%:p:h"),

					-- Display path
					-- Option A
					-- prompt_title = string.format("Find Files (%s)", vim.loop.cwd()),
					-- Option B: Shorten path if too long
					-- TODO: I would like to display the real CWD. Instead, this displays the cwd that is set at startup.
					-- but we are changing the cwd at startup based on the oil buffer,
					-- in order to make the cwd = foo when running 'nvim foo/'
					-- prompt_title = string.format(
					-- 	"Find Files (%s)",
					-- 	require("telescope.utils").buffer_dir()
					-- 	-- require("plenary.path"):new(vim.loop.cwd()):shorten()
					-- ),
				},
				live_grep = {
					-- cwd = require("telescope.utils").buffer_dir(),
					-- prompt_title = string.format("Live grep (%s)", vim.loop.cwd()),
					-- cwd = vim.fn.expand("%:p:h"),
				},
			},
		})

		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- CUSTOM FUNCTIONS FOR PICKERS
		-- Taken from recipes: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes
		---- UTILS
		local function is_git_repo()
			vim.fn.system("git rev-parse --is-inside-work-tree")
			return vim.v.shell_error == 0
		end

		local function get_git_root()
			local dot_git_path = vim.fn.finddir(".git", ".;")
			return vim.fn.fnamemodify(dot_git_path, ":h")
		end

		local function get_cwd_with_fallback()
			local result = ""
			if is_git_repo() then
				result = get_git_root()
				-- return get_git_root()
			else
				result = vim.fn.expand("%:p:h")
				-- return vim.fn.expand("%:p:h")
			end
			-- DEBUG
			-- print(result)
			return result
		end

		local function find_todos_in_project()
			-- Also possible:
			-- require('telescope').extensions['todo-comments'].todo({cwd="~/dotfiles"})
			vim.cmd("TodoTelescope cwd=" .. get_cwd_with_fallback())
		end

		---- FUNCS
		local function live_grep_from_project_git_root()
			local opts = {}

			if is_git_repo() then
				opts = {
					cwd = get_git_root(),
				}
			end

			require("telescope.builtin").live_grep(opts)
		end
		local function find_files_from_project_git_root()
			local opts = {}
			if is_git_repo() then
				opts = {
					cwd = get_git_root(),
				}
			end
			require("telescope.builtin").find_files(opts)
		end

		local function find_hidden_files_from_project_git_root()
			local opts = {}
			if is_git_repo() then
				opts = {
					cwd = get_git_root(),
				}
			end
			opts = {
				find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
			}
			require("telescope.builtin").find_files(opts)
		end

		-- KEYMAPS
		local builtin = require("telescope.builtin")
		-- Files
		vim.keymap.set("n", "<leader>sf", find_files_from_project_git_root, { desc = "[f]iles" })
		vim.keymap.set("n", "<leader>si", find_hidden_files_from_project_git_root, { desc = "[i]nclude hidden files" })
		-- vim.keymap.set("n", "<leader>sg", builtin.git_files, { desc = "Telescope git files" })
		vim.keymap.set("n", "<leader>sr", "<cmd>Telescope oldfiles<cr>", { desc = "[r]ecent files" })
		vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "[b]uffers" })
		-- Strings
		vim.keymap.set("n", "<leader>ss", live_grep_from_project_git_root, { desc = "[s]tring" })
		vim.keymap.set("n", "<leader>s*", "<cmd>Telescope grep_string<cr>", { desc = "string under cursor" })
		-- Other entities
		vim.keymap.set("n", "<leader>st", find_todos_in_project, { desc = "[t]odos" })
		vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Telescope help tags" })
		-- keymap.set("n", "<leader>sc", builtin.commands, { desc = "Telescope commands" })
		vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Telescope keymaps" })
		-- vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
		-- Dotfiles
		vim.keymap.set("n", "<leader>sd", function()
			builtin.find_files({ cwd = "/Users/me/dotfiles/" })
		end, { desc = "[d]otfiles" })
	end,
}
