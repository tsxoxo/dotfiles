local wezterm = require "wezterm"

-- This will hold the configuration.
local config = wezterm.config_builder()

local mux = wezterm.mux

config.term = 'wezterm'

-- config.initial_cols = 100
-- config.initial_rows = 35
-- Open maximized
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Window setting
-- config.window_padding = {
-- 	left = 0,
-- 	right = 0,
-- 	top = 0,
-- 	bottom = 0,
-- }

config.use_resize_increments = false

-- Border
-- local colors = {
--   crust = '#aaaaaa'
-- }
-- config.window_frame = {
--   border_left_width = "1px",
--   border_right_width = "1px",
--   border_bottom_height = "1px",
--   border_top_height = "1px",
--   border_left_color = colors.crust,
--   border_right_color = colors.crust,
--   border_bottom_color = colors.crust,
--   border_top_color = colors.crust,
-- }

-- Add NerdFont
-- Light, Normal
config.freetype_load_target = "Light"
config.font = wezterm.font("MesloLGS NF")
config.font_size = 14

function recompute_line_height(window)
    local window_dims = window:get_dimensions()
    local height = window_dims.pixel_height
    local overrides = window:get_config_overrides() or {}
    
    overrides.line_height = 1.0  -- dynamically set
    window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(window, _)
    recompute_line_height(window)
end)

config.color_scheme = "Catppuccin Mocha"

config.force_reverse_video_cursor = true


-- Don't ask for confirmation on close.
config.window_close_confirmation = "NeverPrompt"

-- Auto reload this config (explicitly set default).
config.automatically_reload_config = true

-- Hide tab bar.
-- config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
-- config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- Key bindings.
config.keys = {
  { key = "u", mods = "ALT", action = wezterm.action.ScrollByPage(-0.5) },
  { key = "d", mods = "ALT", action = wezterm.action.ScrollByPage(0.5) },
}

return config

