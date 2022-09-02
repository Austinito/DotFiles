-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    use 'morhetz/gruvbox'
    use 'geverding/vim-hocon'
    use 'jiangmiao/auto-pairs'
    use 'junegunn/goyo.vim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzy-native.nvim" },
        }
    }
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'

    -- LSP STUFFS ------------------------------------------------------------
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
        }
    }
    --    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    --    use 'L3MON4D3/LuaSnip' -- Snippets plugin

    use 'preservim/nerdcommenter'
    use { 'filipdutescu/renamer.nvim', requires = { "nvim-lua/planary.nvim" } }
    use { 'scalameta/nvim-metals', requires = { "nvim-lua/plenary.nvim" } }

    -- PYTHON SPECIFIC
    use 'ookull/behave-integration.vim'

    use 'theprimeagen/git-worktree.nvim'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-vinegar'

    -- Status Bar
    use 'powerline/powerline-fonts'
    use 'ryanoasis/vim-devicons'

    -- Mine?
    use 'Austinito/scalaimport'
end
)
