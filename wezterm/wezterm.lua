local wezterm = require "wezterm"

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Window setting
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Color theme.
function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
	  -- Mocha, Macchiato, Frappe, Latte
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()) 

config.force_reverse_video_cursor = true

-- Add NerdFont
config.font = wezterm.font("MesloLGS NF")
config.font_size = 18

-- Don't ask for confirmation on close.
config.window_close_confirmation = "NeverPrompt"

-- Auto reload this config (explicitly set default).
config.automatically_reload_config = true

-- Hide tab bar.
config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- Key bindings.
config.keys = {
	{ key = "u", mods = "ALT", action = wezterm.action.ScrollByPage(-0.5) },
	{ key = "d", mods = "ALT", action = wezterm.action.ScrollByPage(0.5) },
}

return config

