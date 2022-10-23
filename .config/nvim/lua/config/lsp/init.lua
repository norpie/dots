local M = {}

function M.setup()
    -- Own
    require('config.lsp.mason').setup()
    require('config.lsp.lspconfig').setup()
    -- General
    require('trouble').setup()
    require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
    require('symbols-outline').setup()
    require('crates').setup()
end

return M
