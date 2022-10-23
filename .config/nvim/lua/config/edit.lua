local M = {}

function M.setup()
    require('nvim-surround').setup()
    require('nvim-autopairs').setup()
    require('config.tabout').setup()
    require('tidy').setup()
end

return M
