-- Functional wrapper for mapping custom keybindings
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = '<'

map('n', '<Leader>g', ':Goyo<CR>', { silent = true })

map('', 'j', 'gj')
map('', 'k', 'gk')
map('', 'Q', 'q')

map('i', '.', '.<C-g>u', { noremap = true })
map('i', ',', ',<C-g>u', { noremap = true })
map('i', '!', '!<C-g>u', { noremap = true })
map('i', '?', '?<C-g>u', { noremap = true })
map('i', ':', ':<C-g>u', { noremap = true })
map('i', ';', ';<C-g>u', { noremap = true })

map('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { noremap = true })
map('n', '<C-p>', ' <cmd>Telescope find_files<cr>', { silent = true })

map('n', 'Y', 'y$')

vim.cmd('cnoreabbrev Write w !sudo tee %')
vim.cmd('cnoreabbrev W w')
