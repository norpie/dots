local M = {}

function M.setup()
    local settings = {
        alpha = 0.75,
        blend_color = "#000000",
        update_in_insert = {
            enable = true,
            delay = 100,
        },
        hide = {
            virtual_text = true,
            signs = true,
            underline = true,
        }
    }

    require("neodim").setup(settings)
end

return M
