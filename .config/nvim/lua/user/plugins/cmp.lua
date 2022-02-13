local cmp = require('cmp')
local lspkind = require('lspkind')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'buffer' },
        { name = 'cmdline' },
        { name = 'path' },
    }),
    experimental = {
        native_menu = false,
        ghost_text = true,
    },
    formatting = {
        -- Youtube: How to set up nice formatting for your sources.
        format = lspkind.cmp_format {
        	with_text = true,
        	menu = {
        	    buffer = "[buf]",
        	    nvim_lsp = "[LSP]",
        	    nvim_lua = "[api]",
        	    path = "[path]",
        	    ultisnips = "[snip]",
        	    gh_issues = "[issues]",
        	    tn = "[TabNine]",
        	},
        },
    }
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig')['html'].setup{}
require('lspconfig')['cssls'].setup{}
require('lspconfig')['jsonls'].setup{}
require('lspconfig')['pylsp'].setup{}
require('lspconfig')['texlab'].setup{}
require('lspconfig')['clangd'].setup{}
require('lspconfig')['vimls'].setup{}
