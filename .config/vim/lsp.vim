" 
" Configuration for the Language Server Protocol
"
set completeopt=menuone,noinsert
let g:completion_auto_change_source = 1
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Language servers
lua require('lspconfig').clangd.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').texlab.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').pylsp.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').jdtls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').bashls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').vimls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').cssls.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').html.setup{on_attach=require('completion').on_attach}
lua require('lspconfig').tsserver.setup{on_attach=require('completion').on_attach}
