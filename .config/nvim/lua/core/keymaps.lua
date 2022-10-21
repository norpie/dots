-- Functional wrapper for mapping custom keybindings
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ' '

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

map('n', '<Leader>z', ':ZenMode<CR>', { silent = true })

map('n', '<Leader>o', ':NvimTreeToggle<CR>', { silent = true })
map('n', '<C-p>', ':Telescope find_files<cr>', { silent = true })

map('', 'j', 'gj')
map('', 'k', 'gk')
map('', 'Q', 'q')

map('i', ',', ',<C-g>u', { noremap = true })
map('i', '.', '.<C-g>u', { noremap = true })
map('i', '!', '!<C-g>u', { noremap = true })
map('i', '?', '?<C-g>u', { noremap = true })
map('i', ':', ':<C-g>u', { noremap = true })
map('i', ';', ';<C-g>u', { noremap = true })

map('i', '<C-l>', '<c-g>u<Esc>[s1z=`]a<c-g>u', { noremap = true }) -- Spelling

map('n', '<Leader>ps', ':PackerSync<CR>')
map('n', '<Leader>pi', ':PackerInstall<CR>')
map('n', '<Leader>pu', ':PackerUpdate<CR>')

map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

map('n', '<C-Up>', ':resize +2<CR>')
map('n', '<C-Down>', ':resize -2<CR>')
map('n', '<C-Left>', ':vertical resize -2<CR>')
map('n', '<C-Right>', ':vertical resize +2<CR>')

map('n', '<Leader>sh', ':split<CR>')
map('n', '<Leader>sv', ':vsplit<CR>')
map('n', '<Leader>st', ':tabedit %<CR>')

map('n', '<Leader>d', ':lua vim.lsp.buf.definition()<CR>')
map('n', '<Leader>p', ':lua vim.lsp.buf.type_definition()<CR>')
map('n', '<Leader>h', ':lua vim.lsp.buf.hover()<CR>')
map('n', '<Leader>f', ':lua vim.lsp.buf.format()<CR>')
map('n', '<Leader>r', ':lua vim.lsp.buf.rename()<CR>')
map('n', '<Leader>q', ':CodeActionMenu<CR>')
map('n', '<Leader>u', ':SymbolsOutline<CR>')

map('n', '<Leader>tt', ':TroubleToggle<CR>')
map('n', '<Leader>tq', ':TroubleToggle quickfix<CR>')
map('n', '<Leader>tw', ':TroubleToggle workspace_diagnostics<CR>')
map('n', '<Leader>td', ':TroubleToggle document_diagnostics<CR>')

map('n', 'Y', 'y$')

map('v', '<C-C>', '"+y')
map('i', '<C-V>', '<Esc>"+pa')

vim.cmd('cnoreabbrev Write w !sudo tee %')
vim.cmd('cnoreabbrev W w')
