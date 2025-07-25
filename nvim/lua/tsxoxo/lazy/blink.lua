-- Autocomplete, refer to https://cmp.saghen.dev/#compared-to-built-in-completion for more information
return {
	"saghen/blink.cmp",
	event = "InsertEnter",
	-- use a release tag to download pre-built binaries
	version = "1.*",
	-- dependencies = {
	-- 	-- optional: provides snippets for the snippet source
	-- 	"L3MON4D3/LuaSnip",
	-- 	version = "v2.*",
	-- 	build = (function()
	-- 		-- Build Step is needed for regex support in snippets.
	-- 		-- This step is not supported in many windows environments.
	-- 		-- Remove the below condition to re-enable on windows.
	-- 		if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
	-- 			return
	-- 		end
	-- 		return "make install_jsregexp"
	-- 	end)(),
	-- 	dependencies = {
	-- 		-- `friendly-snippets` contains a variety of premade snippets.
	-- 		{
	-- 			"rafamadriz/friendly-snippets",
	-- 			config = function()
	-- 				require("luasnip.loaders.from_vscode").lazy_load()
	-- 				require("luasnip.loaders.from_vscode").lazy_load({
	-- 					paths = { vim.fn.stdpath("config") .. "/snippets" },
	-- 				})
	-- 			end,
	-- 		},
	-- 	},
	-- },
	---@module 'blink.cmp'
	-- Refer https://cmp.saghen.dev/installation.html
	opts = {
		enabled = function()
			return not vim.tbl_contains({ "markdown" }, vim.bo.filetype)
		end,
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 'enter' for enter to accept
		-- 'none' for no mappings
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-n/C-p or Up/Down: Select next/previous item
		-- C-e: Hide menu
		-- C-k: Toggle signature help (if signature.enabled = true)
		--
		-- See :h blink-cmp-config-keymap for defining your own keymap
		keymap = {
			preset = "default",
			["<C-n>"] = { "show", "select_next", "fallback_to_mappings" },
			["<C-y>"] = { "select_and_accept" },
		},
		completion = {
			-- Controls whether the documentation window will automatically show when selecting a completion item
			documentation = {
				auto_show = true,
			},
			list = { selection = { preselect = false, auto_insert = false } },
			trigger = {
				show_on_keyword = false,
				show_on_trigger_character = false,
				show_on_x_blocked_trigger_characters = { "=", '"', "'", ".", " ", "\n", "\t" },
			},
			menu = { auto_show = false },
		},
		-- Experimental signature help support
		signature = {
			enabled = false,
		},
		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			-- use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			nerd_font_variant = "mono",
		},
		-- snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
		-- Disable cmdline completions
		cmdline = {
			sources = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				end
				-- Commands
				if type == ":" then
					return { "cmdline" }
				end
				return {}
			end,
		},
	},
	-- without having to redefine it
	opts_extend = {
		"sources.completion.enabled_providers",
		"sources.compat", -- Support nvim-cmp source
		"sources.default",
	},
}
