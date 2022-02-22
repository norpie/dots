-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)

    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- nvim-lua stuff
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- customization
    use 'flazz/vim-colorschemes'
    use 'EdenEast/nightfox.nvim'
    use 'sunjon/shade.nvim'
    use 'onsails/lspkind-nvim'
    use {'nvim-lualine/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    use {'akinsho/bufferline.nvim', requires = 'kyazdani42/nvim-web-devicons'}
    use {'stevearc/dressing.nvim'}

    -- coding
    -- use 'danymat/neogen'

    -- qol
    use 'matze/vim-move'
    use 'windwp/nvim-autopairs'
    use 'nacro90/numb.nvim'
    use "McAuleyPenney/tidy.nvim"
    -- use 'abecodes/tabout.nvim'

    -- utils
    use 'nvim-telescope/telescope.nvim'
    use 'Shougo/deoplete.nvim'
    use 'NFrid/due.nvim'
    -- use 'tpope/vim-fugitive' -- TODO: Maybe start using?
    -- use 'kyazdani42/nvim-tree.lua' -- TODO: Maybe start using?

    -- treesitter
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
    use 'windwp/nvim-ts-autotag'
    use 'p00f/nvim-ts-rainbow'

    -- writing
    use 'dhruvasagar/vim-table-mode'
    use 'lervag/vimtex'
    use {
        'folke/zen-mode.nvim',
        config = function()
            require('zen-mode').setup {
                on_open = function()
                end,
                -- callback where you can add custom code when the Zen window closes
                on_close = function()
                end,
            }
       end
    }

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
