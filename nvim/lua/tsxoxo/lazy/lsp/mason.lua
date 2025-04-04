return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim"
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    mason.setup({
      opts = {
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      }
    })

    mason_lspconfig.setup({
      ensure_installed = {
        "html",
        "cssls",
        "tailwindcss",
        -- TS support in Vue files.
        "ts_ls",
        "volar",
        "lua_ls",
        "emmet_ls",
      }
    })
  end,
}
