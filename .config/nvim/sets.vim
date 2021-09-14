" Sets
syntax enable
set nocompatible
set encoding=utf8
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set smartcase
set wrap
set smartcase
set encoding=utf-8
set noswapfile
set nobackup
set undodir=~/.cache/nvim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=20
set noshowmode
set completeopt=menuone,noinsert,noselect
set shortmess+=c
set cmdheight=1
set updatetime=50
set viminfo+=n~/.cache/nvim/viminfo
set runtimepath+=~/.config/nvim
set ruler

setlocal spell
set spelllang=nl,en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
