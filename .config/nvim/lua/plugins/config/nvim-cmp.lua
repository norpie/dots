local cmp = require('cmp')
local lspkind = require('lspkind')

local select_opts = {behavior = cmp.SelectBehavior.Select}

local lsp = {
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  },
  diagnostic = {
    virtual_text = { spacing = 4, prefix = "●" },
    underline = true,
    update_in_insert = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },
  },
}

-- Diagnostic signs
local diagnostic_signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
for _, sign in ipairs(diagnostic_signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
end

-- Diagnostic configuration
vim.diagnostic.config(lsp.diagnostic)

-- Hover configuration
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp.float)

-- Signature help configuration
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp.float)

cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert'
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete({}), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
        --['<Tab>'] = cmp.mapping(function(fallback)
        --    local col = vim.fn.col('.') - 1

        --    if cmp.visible() then
        --        cmp.select_next_item(select_opts)
        --    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        --        fallback()
        --    else
        --        cmp.complete()
        --    end
        --end, {'i', 's'}),
        --['<S-Tab>'] = cmp.mapping(function(fallback)
        --    if cmp.visible() then
        --        cmp.select_prev_item(select_opts)
        --    else
        --        fallback()
        --    end
        --end, {'i', 's'}),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'ultisnips' }, -- For ultisnips users.
        { name = 'buffer' },
        { name = 'cmdline' },
        { name = 'path' },
    }),
    experimental = {
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


-- Setup lspconfig
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {'cssls', 'jsonls', 'tsserver', 'pylsp', 'pyright', 'texlab', 'clangd', 'vimls', 'rust_analyzer'}

for _, lsp in pairs(servers) do
    require('lspconfig')[lsp].setup {
        init_options = {
            provideFormatter = true
        },
        capabilities = capabilities,
    }
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local lspconfig = require('lspconfig')

--lspconfig.rust_analyzer.setup{
--    --root_dir = lspconfig.util.root_pattern('Cargo.toml'),
--    --settings = {
--    --    cachePriming = {
--    --        enable = true
--    --    },
--    --    procMacro = {
--    --        enable = true
--    --    },
--    --    diagnostics = {
--    --        enable = true,
--    --        enableExperimental = true,
--    --    },
--    --    hoverActions = {
--    --        enable = true,
--    --        debug = true,
--    --        gotoTypeDef = true,
--    --        implementations = true,
--    --        run = true,
--    --        linksInHover = true,
--    --    },
--    --    inlayHints = {
--    --      chainingHints = true,
--    --      parameterHints = true,
--    --      typeHints = true,
--    --    },
--    --},
--    init_options = {
--        provideFormatter = true
--    },
--    capabilities = capabilities,
--}

lspconfig.emmet_ls.setup{
    filetypes = { "html", "tera", "htmldjango", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" }
}

lspconfig.html.setup {
    capabilities = capabilities,
    filetypes = { 'html', 'tera', 'htmldjango' },
}

lspconfig.jdtls.setup{ cmd = { 'jdtls' } }

lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
}
