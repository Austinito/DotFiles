-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function (use)
    use {'wbthomason/packer.nvim', opt = true}

    use 'christoomey/vim-tmux-navigator'
    use 'morhetz/gruvbox'
    use 'geverding/vim-hocon'
    use 'jiangmiao/auto-pairs'
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'junegunn/goyo.vim'
    use 'lambdalisue/fern.vim'
    use 'lambdalisue/fern-hijack.vim'
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'
--    use {'neoclide/coc.nvim', branch = 'release'}

    -- LSP STUFFS ------------------------------------------------------------
    use 'neovim/nvim-lspconfig' -- Collection of configurations for built-in LSP client
    use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp' -- LSP source for nvim-cmp
    use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
    use 'L3MON4D3/LuaSnip' -- Snippets plugin

    use 'preservim/nerdcommenter'

    use 'nvim-lua/plenary.nvim' -- required by nvim-metals
    use 'filipdutescu/renamer.nvim'
    use 'scalameta/nvim-metals'

--    use {'scalameta/coc-metals', run = 'yarn install --rfrozen-lockfile'}

    use 'theprimeagen/git-worktree.nvim'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'

    -- Status Bar
    use 'vim-airline/vim-airline'
    use 'powerline/powerline-fonts'
    use 'ryanoasis/vim-devicons'
end
)


