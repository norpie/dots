local M = {}

function M.setup()
    require("catppuccin").setup {
        flavour = "macchiato" -- mocha, macchiato, frappe, latte
    }
    vim.api.nvim_command "colorscheme catppuccin-macchiato"
end

return M
