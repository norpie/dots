" Terminal color fix
if !has('gui_running')
      set t_Co=256
endif

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" Colorscheme Configuration
colorscheme nord
set background=dark
hi clear Conceal

"" Transparency 
"hi Normal guibg=NONE ctermbg=NONE
"" transparent bg
"autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
"" For Vim<8, replace EndOfBuffer by NonText
"autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE
"
"autocmd! User GoyoLeave hi Normal guibg=NONE ctermbg=NONE


" Lightline Configuration
set laststatus=2
set noshowmode
let g:lightline = {
    \'colorscheme': 'wombat',
    \'enable': {
        \'tabline': 0
    \}
\}
