local plugins = {
    -- Packer can manage itself
    { 'wbthomason/packer.nvim' },

    -- Color themes
    { 'ellisonleao/gruvbox.nvim' },
    { 'Mofiqul/dracula.nvim' },
    { 'folke/tokyonight.nvim' },
    { 'catppuccin/nvim' },

    -- UI changes
    { 'stevearc/dressing.nvim' },
    { 'rcarriga/nvim-notify' },
    {
        'stevearc/aerial.nvim',
        config = function()
            require('aerial').setup()
        end
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup()
        end
    },
    {
        'folke/noice.nvim',
        event = 'VimEnter',
        config = function()
            require('noice').setup()
        end,
        requires = {
            'MunifTanjim/nui.nvim',
        }
    },
    {
        'petertriho/nvim-scrollbar',
        config = function()
            require('scrollbar').setup() -- FIX: not showing up
        end
    },

    -- Appearance
    { 'folke/zen-mode.nvim' },
    { 'levouh/tint.nvim' },
    { 'folke/twilight.nvim' },

    -- Qol plugins
    { 'matze/vim-move' },
    { 'godlygeek/tabular' },
    {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end
    },
    {
        'McAuleyPenney/tidy.nvim',
        config = function()
            require('tidy').setup()
        end
    },
    {
        'abecodes/tabout.nvim',
        after = {
            'nvim-cmp'
        },
        config = function()
            require('config.tabout').setup()
        end
    },

    -- Code editing
    {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup()
        end
    },
    { 'AndrewRadev/splitjoin.vim' },

    -- Code helpers
    { 'RRethy/vim-illuminate' },
    { 'David-Kunz/markid' },
    {
        'zbirenbaum/neodim', -- BUG: no worky
        event = "LspAttach",
        config = function()
            require('config.neodim').setup()
        end
    },
    {
        'folke/todo-comments.nvim',
        config = function()
            require('todo-comments').setup()
        end
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup()
        end
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require('indent_blankline').setup()
        end
    },

    -- Movement
    { 'wellle/targets.vim' },

    -- netrw
    { 'tpope/vim-vinegar' },

    -- Lualine
    {
        'nvim-lualine/lualine.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = function()
            require('config/lualine').setup()
        end
    },
    { 'kylechui/nvim-surround',
        config = function()
            require('nvim-surround').setup()
        end
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        requires = {
            'Zane-/cder.nvim', -- BUG: change config to only show working dir and subs
        },
        config = function()
            require('telescope').load_extension('cder')
        end
    },

    -- Lsp
    {
        'neovim/nvim-lspconfig',
        requires = {
            --'mfussenegger/nvim-jdtls', --TODO: java
            'simrat39/rust-tools.nvim',
            --{
            --    "glepnir/lspsaga.nvim",
            --    branch = "main",
            --    config = function()
            --        local saga = require("lspsaga") TODO: Figure out if iterests

            --        saga.init_lsp_saga({
            --            -- your configuration
            --        })
            --    end,
            --},
            {
                'saecki/crates.nvim',
                event = { "BufRead Cargo.toml" },
                requires = { { 'nvim-lua/plenary.nvim' } },
                config = function()
                    require('crates').setup()
                end,
            },
            {
                'simrat39/symbols-outline.nvim',
                config = function()
                    require('symbols-outline').setup()
                end
            },
            {
                'kosayoda/nvim-lightbulb',
                requires = 'antoinemadec/FixCursorHold.nvim',
                config = function()
                    require('nvim-lightbulb').setup({ autocmd = { enabled = true } })
                end
            },
            {
                'weilbith/nvim-code-action-menu',
                cmd = 'CodeActionMenu',
            },
            {
                'folke/trouble.nvim',
                requires = 'kyazdani42/nvim-web-devicons',
                config = function()
                    require('trouble').setup()
                end
            },
            {
                'williamboman/mason.nvim',
                requires = {
                    'williamboman/mason-lspconfig.nvim'
                }
            }
        },
        config = function()
            require('config/lsp').setup()
        end
    },

    -- cmp
    {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'L3MON4D3/LuaSnip',
            'onsails/lspkind.nvim'
        },
        config = function()
            require('config/cmp').setup()
        end
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'windwp/nvim-ts-autotag',
            'p00f/nvim-ts-rainbow',
            'nvim-treesitter/nvim-treesitter-context',
            'm-demare/hlargs.nvim',
            'RRethy/nvim-treesitter-endwise',
            --'nvim-treesitter/nvim-treesitter-textobjects', -- TODO: figure out
            --'nvim-treesitter-textsubjects',
            --'mfussenegger/nvim-treehopper',
        },
        run = ':TSUpdate',
        config = function()
            require('config/treesitter').setup()
        end
    },

    -- Util
    --{'907th/vim-auto-save'},
    { 'nvim-lua/popup.nvim' },
    { 'nvim-lua/plenary.nvim' },
    { 'lewis6991/impatient.nvim' }
}

vim.cmd 'packadd packer.nvim'

local present, packer = pcall(require, 'packer')

if not present then
    local packer_path = vim.fn.stdpath 'data' .. '/site/pack/packer/opt/packer.nvim'

    print 'Cloning packer..'
    -- remove the dir before cloning
    vim.fn.delete(packer_path, 'rf')
    vim.fn.system {
        'git',
        'clone',
        'https://github.com/wbthomason/packer.nvim',
        '--depth',
        '20',
        packer_path,
    }

    vim.cmd 'packadd packer.nvim'
    present, packer = pcall(require, 'packer')

    if present then
        print 'Packer cloned successfully.'
    else
        error('Couldn\'t clone packer !\nPacker path: ' .. packer_path .. '\n' .. packer)
    end
end

packer.init {
    display = {
        open_fn = function()
            return require('packer.util').float { border = 'single' }
        end,
        prompt_border = 'single',
    },
    git = {
        clone_timeout = 6000, -- seconds
    },
    auto_clean = true,
    compile_on_sync = true,
}

return packer.startup(function(use)
    for _, v in pairs(plugins) do
        use(v)
    end
end)
