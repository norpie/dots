local M = {}

function M.setup()
    local map = require('util').map

    map('n', '<Leader>d', ':lua vim.lsp.buf.definition()<CR>')
    map('n', '<Leader>p', ':lua vim.lsp.buf.type_definition()<CR>')
    map('n', '<Leader>h', ':lua vim.lsp.buf.hover()<CR>')
    map('n', '<Leader>f', ':lua vim.lsp.buf.format()<CR>')
    map('n', '<Leader>r', ':lua vim.lsp.buf.rename()<CR>')
    map('n', '<Leader>q', ':CodeActionMenu<CR>')

    map('n', '<Leader>tt', ':TroubleToggle<CR>')
    map('n', '<Leader>tq', ':TroubleToggle quickfix<CR>')
    map('n', '<Leader>tw', ':TroubleToggle workspace_diagnostics<CR>')
    map('n', '<Leader>td', ':TroubleToggle document_diagnostics<CR>')
end

return M
