hs.window.animationDuration = 0

local hyper = { "ctrl" }

-- Apps
hs.hotkey.bind(hyper, "h", function()
	hs.application.launchOrFocus("WezTerm")
end)

hs.hotkey.bind(hyper, "j", function()
	hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "l", function()
	hs.application.launchOrFocus("Spotify")
end)

hs.hotkey.bind(hyper, ";", function()
	local dosboxApp = hs.application.get("dosbox-x")

	function startDos()
		local task = hs.task.new(
			"/Applications/MacPorts/Dosbox-x.app/Contents/MacOS/Dosbox-x",
			nil,
			{ "-conf", os.getenv("HOME") .. "/dev/asm/dosbox-x.conf" }
		)
		task:start()
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
function reloadConfig(files)
	doReload = false
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
movewindows = require("movewindows")
movewindows.start()

-- Show language picker
-- CLAUDE
hs.hotkey.bind({ "ctrl", "shift" }, "l", function()
	-- Get all input sources
	local inputs = hs.keycodes.layouts()
	local current = hs.keycodes.currentLayout()

	-- Build a chooser
	local chooser = hs.chooser.new(function(choice)
		if choice then
			hs.keycodes.setLayout(choice.text)
		end
	end)

	local choices = {}
	for _, input in ipairs(inputs) do
		local choice = {
			text = input,
			subText = input == current and "Current" or "",
			image = hs.image.imageFromPath(
				"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarFavoritesIcon.icns"
			),
		}
		table.insert(choices, choice)
	end

	chooser:choices(choices)
	chooser:show()
end)
