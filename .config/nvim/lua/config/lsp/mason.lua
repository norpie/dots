local M = {}

function M.setup()
    local mason_options = {
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    }

    local mason_lspconfig_options = {
        ensure_installed = {
            "sumneko_lua"
        },
        automatic_installation = true
    }
    require("mason").setup(mason_options)
    require("mason-lspconfig").setup(mason_lspconfig_options)
end

return M
