-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- THEMES AND UI
    use 'morhetz/gruvbox'
    use 'geverding/vim-hocon'
    use 'junegunn/goyo.vim'
    use 'powerline/powerline-fonts'
    use 'ryanoasis/vim-devicons'
    use {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    }

    -- LSP STUFFS
    use 'neovim/nvim-lspconfig'
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-vsnip" },
            { "hrsh7th/vim-vsnip" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "L3MON4D3/LuaSnip" },
        }
    }
    use { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } }

    -- AI TOOLS
    use 'github/copilot.vim'

    -- PYTHON SPECIFIC
    use 'python-mode/python-mode'
    use 'ookull/behave-integration.vim'

    -- GIT
    use 'tpope/vim-fugitive'

    -- UTILITIES
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzy-native.nvim" },
        }
    }
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter-context'
    use 'nvim-treesitter/playground'

    use 'preservim/nerdcommenter'
    use { 'filipdutescu/renamer.nvim', requires = { "nvim-lua/plenary.nvim" } }
    use 'tpope/vim-surround'
    use 'tpope/vim-vinegar'
    use 'jellyapple102/flote.nvim'

    -- MINE?
    use 'Austinito/scalaimport'
end
)
