local plugins = {
    -- Packer can manage itself
    'wbthomason/packer.nvim',

    -- Theme+
    'ellisonleao/gruvbox.nvim',
    'Mofiqul/dracula.nvim',
    'folke/tokyonight.nvim',
    'catppuccin/nvim',

    -- Visual+
    'lukas-reineke/indent-blankline.nvim',
    'norcalli/nvim-colorizer.lua',
    'folke/todo-comments.nvim',
    'David-Kunz/markid',
    'RRethy/vim-illuminate',
    'nacro90/numb.nvim',
    'folke/zen-mode.nvim',
    --'levouh/tint.nvim',
    'folke/twilight.nvim',
    'petertriho/nvim-scrollbar',
    'folke/noice.nvim',
    'stevearc/dressing.nvim',
    'stevearc/aerial.nvim',
    'nvim-tree/nvim-tree.lua',

    -- Edit+
    'wellle/targets.vim',
    'kylechui/nvim-surround',
    'AndrewRadev/splitjoin.vim',
    'windwp/nvim-autopairs',
    'McAuleyPenney/tidy.nvim',
    'abecodes/tabout.nvim',
    'matze/vim-move',
    'godlygeek/tabular',

    -- Move+
    'phaazon/hop.nvim',

    -- Statusline
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('config/status').setup()
        end,
        requires = {
            'tiagovla/scope.nvim',
            --'akinsho/bufferline.nvim',
            'b0o/incline.nvim'
        }
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        requires = {
            'Zane-/cder.nvim', -- BUG: change config to only show working dir and subs
        },
        config = function()
            require('config/telescope')
        end
    },

    -- Lsp
    {
        'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'jose-elias-alvarez/null-ls.nvim', -- TODO: more research
            --'mfussenegger/nvim-jdtls', -- TODO: java
            'simrat39/rust-tools.nvim',
            'simrat39/symbols-outline.nvim',
            'weilbith/nvim-code-action-menu',
            'folke/trouble.nvim',
            'saecki/crates.nvim',
            'kosayoda/nvim-lightbulb',
            'antoinemadec/FixCursorHold.nvim',
            "glepnir/lspsaga.nvim", -- TODO: Figure out if iterests
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
            'nvim-treesitter/nvim-treesitter-textobjects', --TODO: config
            'RRethy/nvim-treesitter-textsubjects', --TODO: config
            'mfussenegger/nvim-treehopper',
        },
        run = ':TSUpdate',
        config = function()
            require('config/treesitter').setup()
        end
    },

    --{'907th/vim-auto-save'}, --TODO: Find alternative

    -- Multi dependancies
    'MunifTanjim/nui.nvim',
    { 'rcarriga/nvim-notify' },
    { 'nvim-lua/popup.nvim' },
    { 'nvim-lua/plenary.nvim' },
    { 'kyazdani42/nvim-web-devicons' },

    -- netrw
    { 'tpope/vim-vinegar' },

    -- Startup
    { 'lewis6991/impatient.nvim' }
    -- TODO: add alpha
}

local extra_configs = {
    'theme',
    'visual',
    'edit',
    'move',
    'misc'
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

packer.startup(function(use)
    for _, v in pairs(plugins) do
        use(v)
    end
    for _, config in pairs(extra_configs) do
        require('config.' .. config).setup()
    end
end)
