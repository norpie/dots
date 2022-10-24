local M = {}

function M.setup()
    local on_attach = function(client, bufnr)
        require("aerial").on_attach(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
            vim.lsp.diagnostic.on_publish_diagnostics, {
            -- disable virtual text
            virtual_text = true;

            -- show signs
            signs = true,

            -- show_diagnostic_autocmds = { "BufWritePost" },
            show_diagnostic_autocmds = { "InsertLeave", "CursorHoldI" },
        }
        )
    end

    local servers = {
        'cssls',
        'emmet_ls',
        'html',
        'jdtls',
        'jsonls',
        'tsserver',
        'pylsp',
        'pyright',
        'texlab',
        'clangd',
        'vimls',
        'rust_analyzer',
        'sumneko_lua'
    }
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')
    for _, server in pairs(servers) do
        if vim.fn.filereadable(vim.fn.stdpath "config" .. "/lua/config/lsp/servers/" .. server .. ".lua") == 1 then
            local settings = require('config.lsp.servers.' .. server).settings()
            local filetypes = require('config.lsp.servers.' .. server).filetypes()
            lspconfig[server].setup {
                on_attach = on_attach,
                capabilities = capabilities,
                settings = settings,
                filetypes = filetypes
            }
        else
            lspconfig[server].setup {
                init_options = {
                    provideFormatter = true
                },
                on_attach = on_attach,
                capabilities = capabilities,
            }
        end
    end
end

return M
