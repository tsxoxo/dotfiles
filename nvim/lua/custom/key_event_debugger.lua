-- ~/.config/nvim/lua/custom/key_event_debugger.lua

local M = {}

-- Function to set up the terminal debugger keystroke
function M.setup()
  vim.keymap.set('i', 'kd', function()
    local c = vim.fn.getchar()
    local key = vim.fn.nr2char(c)
    print(string.format("Key pressed: decimal=%d, hex=0x%02X, char='%s'", c, c, key))
    return key
  end, { expr = true })

  -- You can add additional debugging utilities here

  -- Log a message to confirm setup is complete
  print 'Terminal debugger initialized. Press F12 in insert mode followed by any key to debug.'
end

return M
