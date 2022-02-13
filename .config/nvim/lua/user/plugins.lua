-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- nvim-lua stuff
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- customization
    use 'flazz/vim-colorschemes'
    use 'onsails/lspkind-nvim'
    use {
        'nvim-lualine/lualine.nvim', 
        requires = { 
            'kyazdani42/nvim-web-devicons', 
            opt = true 
        }
    }

    -- qol
    use 'jiangmiao/auto-pairs'

    -- utils
    use 'nvim-telescope/telescope.nvim'

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    -- writing
    use 'junegunn/goyo.vim'
    use 'junegunn/limelight.vim'

    -- cmp
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-path'
    use 'hrsh7th/cmp-cmdline'

    use 'SirVer/ultisnips'
    use 'quangnguyen30192/cmp-nvim-ultisnips'

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/cmp-nvim-lsp'

end)
