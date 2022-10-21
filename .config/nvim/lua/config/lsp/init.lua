local M = {}

function M.setup()
    require('config.lsp.mason').setup()
    require('config.lsp.lspconfig').setup()
end

return M
