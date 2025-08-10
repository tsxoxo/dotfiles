-- hs.loadSpoon("EmmyLua")

hs.window.animationDuration = 0

local hyper = { "ctrl cmd alt shift" }

-- Apps
hs.hotkey.bind(hyper, "r", function()
	hs.application.launchOrFocus("Preview")
end)

hs.hotkey.bind(hyper, "f", function()
	hs.application.launchOrFocus("Finder")
end)

hs.hotkey.bind(hyper, "h", function()
	hs.application.launchOrFocus("WezTerm")
end)

hs.hotkey.bind(hyper, "j", function()
	hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "g", function()
	local app = hs.application.get("Chromium")
	if app then
		local windows = app:allWindows()
		for _, win in ipairs(windows) do
			if string.match(win:title(), "Playwright") then
				win:focus()
				return
			end
		end
	end
end)

hs.hotkey.bind(hyper, "l", function()
	hs.application.launchOrFocus("Spotify")
end)

-- toggle between keyboard layouts: real prog iso -- german
---@type Lang
local lang = require("lang")
hs.hotkey.bind(hyper, "t", function()
	lang.switch_ger_and_realprog()
end)

-- show date
hs.hotkey.bind(hyper, "s", function()
	hs.alert.show(os.date())
end)

-- for the old dosbox shortcut, see github.com/tsxoxo/asm

-- Reload config automatically when the file changes
local function reloadConfig(files)
	local doReload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			doReload = true
		end
	end
	if doReload then
		hs.reload()
	end
end

-- Watch for changes in the Hammerspoon directory
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- Display a notification when the config is loaded
hs.alert.show("Hammerspoon config loaded")

-- From https://github.com/evantravers/hammerspoon-config
local movewindows = require("movewindows")
movewindows.start()
