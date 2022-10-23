local M = {}

function M.setup()
    require('telescope').load_extension('cder')

    local map = require('util').map
    vim.notify("test")
    map('n', '<C-p>', ':Telescope find_files<cr>', { silent = true })
end

return M
