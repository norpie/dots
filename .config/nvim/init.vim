"""""""""""""""""""""""""""""" 
" norpie's Vim Configuration "
""""""""""""""""""""""""""""""

"""""""""""
" PLUGINS "
"""""""""""

filetype off
set rtp+=~/.config/nvim
call plug#begin('~/.config/nvim/plugged')

Plug 'junegunn/vim-plug'

Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

Plug 'preservim/tagbar'
Plug 'preservim/nerdtree'

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'

Plug 'rstacruz/vim-closer'

Plug 'itchyny/lightline.vim'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

Plug 'flazz/vim-colorschemes'

Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'sirver/ultisnips'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

Plug 'nvim-telescope/telescope.nvim'

Plug 'mbbill/undotree'

call plug#end()

filetype plugin indent on

""""""""
" Sets "
""""""""

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
set wrap
set ignorecase
set smartcase
set ruler
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
set cmdheight=1
set updatetime=50
set background=dark
set viminfo+=n~/.cache/nvim/viminfo
set runtimepath+=~/.config/nvim
set spelllang=nl,en_gb
set laststatus=2
set noshowmode
set conceallevel=1
set completeopt=menuone,noinsert
set omnifunc=v:lua.vim.lsp.omnifunc

let mapleader="<"
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:completion_auto_change_source = 1
let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_popup = 1
let g:completion_enable_snippet = "UltiSnips"
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_ignore_case = 1
let g:completion_trigger_character = ['.', '::']
let g:completion_confirm_key = "\<tab>"
let g:completion_trigger_keyword_length = 1 " default = 1
let g:completion_trigger_on_delete = 1
let g:limelight_conceal_ctermfg = 100
let g:limelight_conceal_guifg = '#83a598'
let g:tex_conceal='abdmg'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ['snips']
let g:UltiSnipsSnippetsDir = "~/.config/nvim/snips"

let g:lightline = {
    \'colorscheme': 'wombat',
    \'enable': {
        \'tabline': 0
    \}
\}

let g:completion_chain_complete_list = [
    \{'complete_items': ['vimtex']},
    \{'complete_items': ['lsp']},
    \{'complete_items': ['snippet']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

setlocal spell

if !has('gui_running')
      set t_Co=256
endif

""""""""""""""""
" Colorschemes "
""""""""""""""""

colorscheme nord
hi clear Conceal

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

"""""""""""""
" LSP SETUP "
"""""""""""""

lua require('lspconfig').clangd.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').texlab.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').pylsp.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').jdtls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').bashls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').vimls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').jsonls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').cssls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').html.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').tsserver.setup{on_attach=require('completion').on_attach}

""""""""""""
" MAPPINGS "
""""""""""""

cnoreabbrev W w !sudo tee %
nmap <Leader>n :NERDTreeToggle<CR>
nmap <Leader>t :TagbarToggle<CR>
nmap <Leader>g :Goyo<CR>
nmap gd :lua vim.lsp.buf.definition()<CR>
nmap gb <C-o>
imap <C-Space> :silent <Plug>(completion_trigger)
map j gj
map k gk
map Q q
inoremap . .<C-g>u
inoremap , ,<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u
inoremap : :<C-g>u
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <C-p> <cmd>Telescope find_files<cr>

""""""""""""
" AUTOCMDS "
""""""""""""

autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!
autocmd FileType python,java,cpp,c TagbarOpen
autocmd FileType python,java,cpp,c set nowrap

autocmd BufEnter * lua require'completion'.on_attach()

augroup latexautocompile
    autocmd! 
    autocmd CursorHold *.tex write
    autocmd CursorHoldI *.tex write
    autocmd InsertEnter *.tex write
    autocmd InsertLeave *.tex write
    autocmd InsertChange *.tex write
augroup END

augroup writegroup
    autocmd!
    autocmd BufWritePost init.vim source %
    autocmd BufWritePost Xresources silent !xrdb -merge ~/.config/X11/Xresources
    autocmd BufWritePost dunstrc silent !restart-dunst && notify-send "dunstrc saved\! 💾"
augroup END
