local M = {}

function M.setup()
    -- Own
    require('config.lsp.mason').setup()
    require('config.lsp.lspconfig').setup()
    require('config.lsp.keymaps').setup()
    -- General
    require('trouble').setup()
    require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
    require('symbols-outline').setup()
    require('crates').setup()
    --
    --local saga = require("lspsaga")
    --local sage_settings = {}

    --saga.init_lsp_saga(sage_settings)
end

return M
