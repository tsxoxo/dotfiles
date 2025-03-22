-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Window setting
config.window_padding = {
	left = 16,
	right = 16,
	top = 16,
	bottom = 16,
}

-- Color theme.
config.color_scheme = "Tokyo Night"

-- Add NerdFont
config.font = wezterm.font("MesloLGS NF")
config.font_size = 18

-- Don't ask for confirmation on close.
config.window_close_confirmation = "NeverPrompt"

-- Auto reload this config (explicitly set default).
config.automatically_reload_config = true

-- Hide tab bar.
config.enable_tab_bar = false

-- Key bindings.
config.keys = {
	{ key = "u", mods = "ALT", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "d", mods = "ALT", action = wezterm.action.ScrollByPage(0.5) },
}

-- and finally, return the configuration to wezterm
return config
