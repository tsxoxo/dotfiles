return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    -- 'auto' to follow OS theme
    -- flavour = "mocha",
    -- :h background
    -- background = {
    --   -- latte, mocha, frappe, macchiato
    --   light = "latte",
    --   dark = "mocha",
    -- },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = true, -- shows the '~' characters after the end of buffers
    -- term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = true, -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
  },
  config = function()
    -- vim.cmd.colorscheme "catppuccin"
    vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha

    require("catppuccin").setup()

    vim.cmd [[colorscheme catppuccin]]
    -- Make windows transparent?
    -- vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
    -- vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
  end,
}
