local map = require('util').map

map('n', '<Leader>z', ':ZenMode<CR>', { silent = true })

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
map('n', '<C-p>', ':Telescope find_files<cr>', { silent = true })

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

map('n', 'gt', ':bnext<CR>')
map('n', 'gT', ':bprev<CR>')

map('n', '<Leader>sh', ':split<CR>')
map('n', '<Leader>sv', ':vsplit<CR>')

map('n', '<Leader>ot', ':NvimTreeToggle<CR>', { silent = true })
map('n', '<Leader>os', ':SymbolsOutline<CR>')
map('n', '<Leader>oa', ':AerialToggle!<CR>')
map('n', '<Leader>oc', ':Telescope cder<CR>')

map('n', 'Y', 'y$')

map('v', '<C-C>', '"+y')
map('i', '<C-V>', '<Esc>"+pa')

vim.cmd('cnoreabbrev Write w !sudo tee %')
vim.cmd('cnoreabbrev W w')
