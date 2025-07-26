---@class Lang
local M = {}

-- Switch between keyboard layouts -- german, qwerty
function M.switch_ger_and_realprog()
	local current = hs.keycodes.currentLayout()
	local new_layout = current == "German" and "real prog qwerty ISO" or "German"

	if not hs.keycodes.setLayout(new_layout) then
		hs.alert.show("Error: can't find layout " .. new_layout)
	end
	hs.alert.show(new_layout)
end

-- Show language picker
-- UNUSED
-- CLAUDE
function M.show_language_picker()
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
end

return M
