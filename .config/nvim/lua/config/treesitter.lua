local M = {}

function M.setup()
    require('nvim-treesitter.configs').setup {
        -- One of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = "all",

        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- List of parsers to ignore installing
        ignore_install = {},

        autotag = {
            enable = true,
        },
        highlight = {
            -- `false` will disable the whole extension
            enable = true,

            -- list of language that will be disabled
            disable = {
                'markdown',
            },

            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = 'latex'
        },
        endwise = {
            enable = true,
        },
        markid = {
            enable = true
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
        }
    }
    require('aerial').setup()
end

return M
