--for _, module in ipairs(plugins) do
--    local ok, err = pcall(require, module)
--    if not ok then
--        vim.notify("Error loading " .. module .. "\n\n" .. err)
--end
-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local packer = require('plugins.packer_init')

return packer.startup(function(use)

    -- Packer can manage itself
    use {'wbthomason/packer.nvim'}

    -- nvim-lua stuff
    use {'nvim-lua/popup.nvim'}
    use {'nvim-lua/plenary.nvim'}

    -- customization
    use {'flazz/vim-colorschemes'}
    use {'EdenEast/nightfox.nvim'}
    use {
        'sunjon/shade.nvim',
        config = function()
            require('plugins.config.shade-nvim')
        end
    }
    use {'onsails/lspkind-nvim'}
    use {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('plugins.config.lualine-nvim')
        end,
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }
    use {'stevearc/dressing.nvim'}

    -- coding
    -- use 'danymat/neogen' -- TODO: Check this out

    -- qol
    use {'matze/vim-move'}
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('plugins.config.nvim-autopairs')
        end
    }
    use {
        'nacro90/numb.nvim',
        config = function()
            require('numb').setup()
        end
    }
    use {'McAuleyPenney/tidy.nvim'}
    -- use 'abecodes/tabout.nvim'

    -- utils
    use {'nvim-telescope/telescope.nvim'}
    use {'Shougo/deoplete.nvim'}
    use {'NFrid/due.nvim'}
    -- use 'tpope/vim-fugitive' -- TODO: Maybe start using?
    -- use 'kyazdani42/nvim-tree.lua' -- TODO: Maybe start using?

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('plugins.config.nvim-treesitter')
        end
    }
    use {'windwp/nvim-ts-autotag'}
    use {'p00f/nvim-ts-rainbow'}

    -- writing
    use {
        'dhruvasagar/vim-table-mode',
        config = function()
            require('plugins.config.vim-table-mode')
        end
    }
    use {
        'lervag/vimtex',
        config = function()
            require('plugins.config.vimtex')
        end
    }
    use {'folke/zen-mode.nvim'}

    -- cmp
    use {
        'hrsh7th/nvim-cmp',
        config = function()
            require('plugins.config.nvim-cmp')
        end
    }
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-path'}
    use {'hrsh7th/cmp-cmdline'}

    use {
        'SirVer/ultisnips',
        config = function()
            require('plugins.config.ultisnips')
        end
    }
    use {'quangnguyen30192/cmp-nvim-ultisnips'}

    use {'neovim/nvim-lspconfig'}
    use {'hrsh7th/cmp-nvim-lsp'}

end)
