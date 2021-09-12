" Lets
let mapleader="<"

" Custom aliases
cnoreabbrev W w !sudo tee %

" Custom Plugin Mappings
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>t :TagbarToggle<CR>
nmap <Leader>g :Goyo<CR>

" Ale
nmap gd :lua vim.lsp.buf.definition()<CR>
nmap gb <C-o>

" Lsp
" " Trigger completion with <Tab>
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ completion#trigger_completion()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" Fix kj with wrapping
map j gj
map k gk

" Undo points at punctuation marks
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u
