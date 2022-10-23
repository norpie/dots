local M = {}

function M.setup()
    require('indent_blankline').setup()
    require('colorizer').setup()
    require('todo-comments').setup()
    require('numb').setup()
    --require("tint").setup({})
    require('scrollbar').setup()
    require('noice').setup()
    require('nvim-tree').setup()
end

return M
