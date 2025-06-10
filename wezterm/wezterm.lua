local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()
local mux = wezterm.mux
config.term = "wezterm"

-- STARTUP BEHAVIOR
-- Open maximized
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.default_prog = {
	"/bin/zsh",
	"-l",
	"-c",
	"tmux attach || tmux new-session 2> ~/wezerror.log",
}

-- Window setting
-- config.window_padding = {
-- 	left = 0,
-- 	right = 0,
-- 	top = 0,
-- 	bottom = 0,
-- }

config.use_resize_increments = false

-- Add NerdFont
-- Light, Normal
config.freetype_load_target = "Normal"
config.font = wezterm.font("MesloLGS NF")
config.font_size = 14

config.color_scheme = "Catppuccin Mocha"

config.force_reverse_video_cursor = true

-- Don't ask for confirmation on close.
config.window_close_confirmation = "NeverPrompt"

-- Auto reload this config (explicitly set default).
config.automatically_reload_config = true

-- Hide tab bar.
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

config.window_decorations = "RESIZE"

-- Key bindings.
config.keys = {
	{ key = "UpArrow", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "DownArrow", action = wezterm.action.ScrollByPage(0.5) },
}

return config
