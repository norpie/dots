filetype off
set rtp+=~/.config/nvim
call plug#begin('~/.config/nvim/plugged')

" Vim Lua dependancies
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'

" Plugin Manager
Plug 'junegunn/vim-plug'
Plug 'junegunn/fzf'

" Utility Gui
Plug 'preservim/tagbar'
Plug 'preservim/nerdtree'

" Auto-Complete
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
" Auto-Complete - Sub plugins
Plug 'onsails/lspkind-nvim'

" Generic Programming Helpers
Plug 'Townk/vim-autoclose'

" Cool looks
Plug 'kyazdani42/nvim-web-devicons'
Plug 'itchyny/lightline.vim'
Plug 'lukas-reineke/indent-blankline.nvim'

" Writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" Colorschemes
Plug 'flazz/vim-colorschemes'

" Notetaking
Plug 'lervag/vimtex'
Plug 'KeitaNakamura/tex-conceal.vim'
Plug 'sirver/ultisnips'

" Utilities
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-speeddating'

" File browsing
Plug 'nvim-telescope/telescope.nvim'

" General Improvements
Plug 'mbbill/undotree'

call plug#end()

filetype plugin indent on

" Vimtex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

" Configuration for the Language Server Protocol
set completeopt=menuone,noinsert
set omnifunc=v:lua.vim.lsp.omnifunc

let g:completion_auto_change_source = 1

let g:completion_enable_auto_hover = 1
let g:completion_enable_auto_signature = 1
let g:completion_enable_auto_popup = 1
let g:completion_enable_snippet = "UltiSnips"

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_matching_ignore_case = 1

let g:completion_trigger_character = ['.', '::']
let g:completion_trigger_keyword_length = 2 " default = 1
let g:completion_trigger_on_delete = 1

" non ins-complete method should be specified in 'mode'
let g:completion_chain_complete_list = [
    \{'complete_items': ['vimtex']},
    \{'complete_items': ['lsp']},
    \{'complete_items': ['snippet']},
    \{'mode': '<c-p>'},
    \{'mode': '<c-n>'}
\]

" Language servers
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

" Tex-conceal
set conceallevel=1
let g:tex_conceal='abdmg'

" UltiSnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetDirectories = ['snips']
let g:UltiSnipsSnippetsDir = "~/.config/nvim/snips"

" Goyo
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 100

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = '#83a598'

" Telescope
nnoremap <C-p> <cmd>Telescope find_files<cr>
