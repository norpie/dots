local present, packer = pcall(require, 'plugins.packer_init')

if not present then
   return false
end

local plugins = {

    -- Packer can manage itself
    {'wbthomason/packer.nvim'},

    -- dependancies
    {'kyazdani42/nvim-web-devicons'},

    -- nvim-lua stuff
    {'nvim-lua/popup.nvim'},
    {'nvim-lua/plenary.nvim'},

    -- customization
    {'flazz/vim-colorschemes'},
    {'EdenEast/nightfox.nvim'},
    {
        'levouh/tint.nvim',
        config = function()
            require('plugins.config.tint-nvim')
        end
    },
    {'onsails/lspkind-nvim'},
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('plugins.config.lualine-nvim')
        end,
    },
    {'stevearc/dressing.nvim'},

    -- coding
    -- 'danymat/neogen' -- TODO: Check this out

    -- qol
    {'matze/vim-move'},
    {
        'windwp/nvim-autopairs',
        config = function()
            require('plugins.config.nvim-autopairs')
        end
    },
    {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end
    },
    {
        'McAuleyPenney/tidy.nvim',
        branch = 'main'
    },
    -- 'abecodes/tabout.nvim'

    -- utils
    {'nvim-telescope/telescope.nvim'},
    {'godlygeek/tabular'},
    {'Shougo/deoplete.nvim'},
    {'NFrid/due.nvim'},
    -- 'tpope/vim-fugitive' -- TODO: Maybe start using?
    -- 'kyazdani42/nvim-tree.lua' -- TODO: Maybe start using?

    -- treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('plugins.config.nvim-treesitter')
        end
    },
    {'windwp/nvim-ts-autotag'},
    {'p00f/nvim-ts-rainbow'},

    -- writing
    {
        'dhruvasagar/vim-table-mode',
        config = function()
            require('plugins.config.vim-table-mode')
        end
    },
    {
        'lervag/vimtex',
        config = function()
            require('plugins.config.vimtex')
        end
    },
    {"vim-pandoc/vim-pandoc-syntax"},
    {"plasticboy/vim-markdown"},
    {"elzr/vim-json"},
    {'folke/zen-mode.nvim'},

    -- cmp
    {
        'hrsh7th/nvim-cmp',
        config = function()
            require('plugins.config.nvim-cmp')
        end
    },
    {'hrsh7th/cmp-buffer'},
    {'hrsh7th/cmp-path'},
    {'hrsh7th/cmp-cmdline'},

    {
        'SirVer/ultisnips',
        config = function()
            require('plugins.config.ultisnips')
        end
    },
    {'quangnguyen30192/cmp-nvim-ultisnips'},

    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
}

return packer.startup(function(use)
    for _, v in pairs(plugins) do
        use(v)
    end
end)
