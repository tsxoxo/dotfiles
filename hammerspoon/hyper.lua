-- Copied from https://github.com/evantravers/hammerspoon-config
-- See also https://github.com/evantravers/Hyper.spoon?tab=readme-ov-file
--
-- HYPER
--
-- Set up a modal key that enters the mode on keypress and exits on release.
--
-- Used for moving windows.
--
---@class MyHyper : hs.hotkey.modal
---@field pressed fun()
---@field released fun()

local hyper = hs.hotkey.modal.new({}, nil)
---@cast hyper MyHyper

hyper.pressed = function()
	hyper:enter()
end

hyper.released = function()
	hyper:exit()
end

hs.hotkey.bind({}, "F19", hyper.pressed, hyper.released)

return hyper
