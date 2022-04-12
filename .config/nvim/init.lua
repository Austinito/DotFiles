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

require("renamer").setup()
--vim.lsp.set_log_level('trace')

opt.statusline = "%!luaeval('Austinito_custom_status_line()')"

----------------------------------
-- CONFIGURE PLUGINS -------------
----------------------------------

require("configs.treesitter")
require("configs.telescope")
--require("configs.airline")
cmd([[hi! StatusLine guifg=#5C6370 guibg=#282c34]])
cmd([[hi! link StatusError DiagnosticError]])
cmd([[hi! link StatusWarn DiagnosticWarn]])

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

map("n", "<leader><cr>", "<cmd>source $MYVIMRC<CR>")
map("n", "<leader>vrc", "<cmd>edit $MYVIMRC<CR>")

map("n", "<leader><space>", "<cmd>lua print([[You're doing great!]])<CR>")
map("n", "Q", [[<cmd>lua require("settings.functions").toggle_quickfix()<CR>]])

-- Directory Navigation
map("n", "-", "<cmd>Fern %:h<CR>")
map("n", "_", "<cmd>Fern .<CR>")
map("n", "E", "<cmd>Fern . -drawer -toggle<CR>")

-- Buffer Navigation
map("n", "<leader>x", "<cmd>bprevious <BAR> bdelete #<CR>")
map("n", "<leader>n", "<cmd>enew<CR>")
map("n", "<leader>,", "<cmd>bnext<CR>")
map("n", "<leader>.", "<cmd>bprevious<CR>")

-- Window Naviation With Tmux
--map("n", "<C-w>h", "<cmd>TmuxNavigateLeft<CR>")
--map("n", "<C-w>j", "<cmd>TmuxNavigateDown<CR>")
--map("n", "<C-w>k", "<cmd>TmuxNavigateUp<CR>")
--map("n", "<C-w>l", "<cmd>TmuxNavigateRight<CR>")
--map("n", "<C-w>p", "<cmd>TmuxNavigatePrevious<CR>")

---- Fuzzy Finder
map("n", "<leader><tab>", "<Plug>(fzf-maps-n)")
--map("n", "<leader>F", "<cmd>Files<CR>")
map("n", "<leader>F", [[<cmd> lua require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})<CR>]])

-- Git Worktree
-- show the worktre
map("n", "<leader>B", [[<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>]])

-- LSP
--map("n", "<C-K>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
map("n", "<C-K>", "<cmd>lua require('metals').hover_worksheet()<CR>")
map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "<C-k>", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
map("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
map("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
map("n", "<leader>wl", "<cmd>lua vim.inspect(vim.lsp.buf.list_workspace_folders())<CR>")
map("n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
map("n", "<leader>rn", [[<cmd>lua require("renamer").rename()<CR>]])
map("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<leader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
map("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
map("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
map("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("v", "<leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>")

------------------------------------
---- COMMANDS ----------------------
------------------------------------
-- Autocmd to trim whitespace
vim.api.nvim_exec(
[[
function! TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction
autocmd FileType * autocmd BufWritePre <buffer> call TrimWhiteSpace()
]],
false
)

cmd "colorscheme gruvbox"

cmd [[set isfname+=@-@]]
cmd [[set guicursor=a:block-blinkon0]]
cmd [[set clipboard+=unnamedplus]]
cmd [[set formatoptions-=cro]]
cmd [[let NERDDefaultAlign='start']]

-- LSP
cmd [[augroup lsp
autocmd!
autocmd FileType scala setlocal omnifunc=v:lua.vim.lsp.omnifunc
autocmd FileType scala,sbt lua require("metals").initialize_or_attach(Metals_config)
augroup end]]
