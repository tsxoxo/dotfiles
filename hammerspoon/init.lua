-- hs.loadSpoon("EmmyLua")

hs.window.animationDuration = 0

local hyper = { "ctrl cmd alt shift" }

-- Apps
hs.hotkey.bind(hyper, "h", function()
	hs.application.launchOrFocus("WezTerm")
end)

hs.hotkey.bind(hyper, "j", function()
	hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "n", function()
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

---@type Lang
local lang = require("lang")
hs.hotkey.bind(hyper, "t", function()
	lang.switch_ger_and_realprog()
end)

-- dosbox
hs.hotkey.bind(hyper, ";", function()
	local dosboxApp = hs.application.get("dosbox-x")

	local function startDos()
		local task = hs.task.new(
			"/Applications/MacPorts/Dosbox-x.app/Contents/MacOS/Dosbox-x",
			nil,
			{ "-conf", os.getenv("HOME") .. "/dev/asm/dosbox-x.conf" }
		)
		task:start()
		hs.alert.show("Starting Dosbox...")
	end
	-- If we found the app, focus it
	if dosboxApp then
		local status, err = pcall(function()
			dosboxApp:activate()
		end)
		if not status then
			print("Error launching dosbox: " .. err)
			startDos()
		end
	else
		-- Launch it if not found
		startDos()
	end
end)

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
