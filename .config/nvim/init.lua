-- Helper functions
local cmd = vim.cmd
--local fn = vim.fn
local opt = vim.opt
local map = require("settings.functions").map

----------------------------------
-- SETUP PLUGINS -----------------
----------------------------------
cmd([[packadd packer.nvim]])
require("plugins")
require("sets")
require("settings.cmp").setup()
require("settings.lsp").setup()
require("settings.statusline")
require("settings.functions")

require("renamer").setup({})
--vim.lsp.set_log_level('trace')

----------------------------------
-- CONFIGURE PLUGINS -------------
----------------------------------

require("configs.treesitter")
require("configs.telescope")
cmd([[hi! StatusLine guifg=#5C6370 guibg=#282c34]])
cmd([[hi! link StatusError DiagnosticError]])
cmd([[hi! link StatusWarn DiagnosticWarn]])

opt.statusline = "%!luaeval('Austinito_custom_status_line()')"

----------------------------------
-- VARIABLES ---------------------
----------------------------------

------------------------------------
---- SETUP MAPPINGS ----------------
------------------------------------
-- General
map("n", "J", "<cmd>move +1<CR>")
map("n", "K", "<cmd>move -2<CR>")
map("v", "J", ":m '>+1<CR>gv")
map("v", "K", ":m '<-2<CR>gv")

map("i", "<C-c>", "<esc>")
map("n", "<F2>", "<cmd>call TrimWhiteSpace()<CR>")

map("n", "<leader><cr>", "<cmd>source $MYVIMRC<CR><cmd>lua print('sourced.')<CR>")
map("n", "<leader>vrc", "<cmd>edit $MYVIMRC<CR>")

map("n", "Q", [[<cmd>lua require("settings.functions").toggle_quickfix()<CR>]])
map("n", "qn", [[<cmd>cnext<CR>]])
map("n", "qp", [[<cmd>cprev<CR>]])

-- Directory Navigation
map("n", "-", "<cmd>Explore<CR>")
map("n", "_", "<cmd>Explore $PWD<CR>")

-- Buffer Navigation
map("n", '<leader>x', '<cmd>bprevious <BAR> bdelete #<CR>')
map("n", '<leader>n', '<cmd>enew<CR>')
map("n", '<leader>,', '<cmd>bnext<CR>')
map("n", '<leader>.', '<cmd>bprevious<CR>')

-- Fuzzy Finder
map("n", "<leader><TAB>", [[<cmd> lua require('telescope.builtin').keymaps()<CR>]])
map("n", "<leader>sf", [[<cmd> lua require('telescope.builtin').find_files({hidden=true})<CR>]])
map("n", "<leader>sb", [[<cmd> lua require('telescope.builtin').git_branches()<CR>]])
map("n", "<leader>sB", [[<cmd> lua require('telescope.builtin').buffers()<CR>]])
map("n", "<leader>sg", [[<cmd> lua require('telescope.builtin').live_grep()<CR>]])

-- Git Worktree
-- show the worktre
map("n", "<leader>sw", [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]])
map("n", "<leader>aw", [[<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]])
map("n", "<leader>sw", [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]])
map("n", "<leader>aw", [[<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>]])

-- LSP
map("n", "<C-K>", "<cmd>lua require('metals').hover_worksheet()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
--map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")Moved to lsp
--map("n", "<C-k>", "<cmd>lua vim.lsp.buf.hover()<CR>")Moved to lsp
--map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")Moved to lsp
--map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")Moved to lsp
--map("n", "<leader>rn", [[<cmd>lua vim.lsp.buf.rename()<CR>]])Moved to lsp
--map("n", "<leader><space>", "<cmd>lua vim.lsp.buf.code_action()<CR>") Moved to lsp
--map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>") Moved to lsp
--map("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>") DEPRECATED

map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
--map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>") Moved to lsp
--map("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")

-- temporary
--
map("n", "<leader>oi", "<cmd>lua require('scalaimport').organize_imports()<CR>")
map("n", "<leader>tr", "<cmd>lua package.loaded.ts = nil<cr>")
map("n", "<leader>tt", "<cmd>lua require 'ts-import'.tf()<cr>")
map("n", "<leader><leader>j", "<cmd>lua require('jenkinsfile_linter').validate()<CR>")
require('jenkinsfile_linter')
--
--
--#region
------------------------------------
---- COMMANDS ----------------------
------------------------------------
-- function to trim all trailing whitespace in the file without moving the cursor
cmd [[function! TrimWhiteSpace()
  %s/\s*$//
  ''
  endfunction]]

-- Automatically trim trailing whitespace on save
cmd [[autocmd FileType * autocmd BufWritePre <buffer> call TrimWhiteSpace()]]

------------------------------------
---- LAST MINUTE OVERRIDES ---------
------------------------------------
cmd [[colorscheme gruvbox]]
cmd [[hi Normal guibg=NONE ctermbg=NONE]]

cmd [[set isfname+=@-@]]
cmd [[set guicursor=a:block-blinkon0]]
cmd [[set clipboard+=unnamedplus]]
cmd [[set formatoptions-=cro]]
cmd [[let NERDDefaultAlign='start']]
vim.opt_global.shortmess:remove("F")

-- when working with mardown files, we want wrap enabled.
cmd [[autocmd FileType markdown set wrap]]

-- LSP
--autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
--cmd [[augroup lsp
--autocmd!
--autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)
--autocmd FileType scala autocmd BufWritePre lua vim.lsp.buf.formating_sync()
--augroup end]]
