local M = {}

function M.setup()
    require("catppuccin").setup {
        flavour = "macchiato" -- mocha, macchiato, frappe, latte
    }
    vim.api.nvim_command "colorscheme catppuccin-macchiato"
    local highlight = require('util').highlight

    highlight(0, 'VertSplit', {
        fg = '#202233'
    })
end

return M
