hs.window.animationDuration = 0

local hyper = {"ctrl"}

-- Apps
hs.hotkey.bind(hyper, "h", function()
    hs.application.launchOrFocus("WezTerm")
end)

hs.hotkey.bind(hyper, "j", function()
    hs.application.launchOrFocus("Google Chrome")
end)

hs.hotkey.bind(hyper, "k", function()
    hs.application.launchOrFocus("Spotify")
end)

-- Reload config automatically when the file changes
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
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
movewindows = require('movewindows')
movewindows.start()
