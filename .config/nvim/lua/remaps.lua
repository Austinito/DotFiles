vim.g.mapleader = " "

-- General
vim.keymap.set("v", "J", ":m '>+1<CR>gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv")

vim.keymap.set("i", "<C-c>", "<esc>")
vim.keymap.set("n", "<F2>", "<cmd>call TrimWhiteSpace()<CR>")

vim.keymap.set("n", "<leader><cr>", "<cmd>source $MYVIMRC<CR><cmd>lua print('sourced.')<CR>")
vim.keymap.set("n", "<leader>vrc", "<cmd>edit $MYVIMRC<CR>")

vim.keymap.set("n", "Q", [[<cmd>lua require("settings.functions").toggle_quickfix()<CR>]])
vim.keymap.set("n", "<C-q>n", [[<cmd>cnext<CR>]])
vim.keymap.set("n", "<C-q>p", [[<cmd>cprev<CR>]])

vim.keymap.set("x", "<leader>p", [["_dP]])

-- Directory Navigation
vim.keymap.set("n", "-", "<cmd>Explore<CR>")
vim.keymap.set("n", "_", "<cmd>Explore $PWD<CR>")

-- Buffer Navigation
vim.keymap.set("n", '<leader>x', '<cmd>bprevious <BAR> bdelete #<CR>')
vim.keymap.set("n", '<leader>n', '<cmd>enew<CR>')
vim.keymap.set("n", '<leader>,', '<cmd>bnext<CR>')
vim.keymap.set("n", '<leader>.', '<cmd>bprevious<CR>')

-- Fuzzy Finder
vim.keymap.set("n", "<leader><TAB>", [[<cmd> lua require('telescope.builtin').keymaps()<CR>]])
vim.keymap.set("n", "<leader>sf", [[<cmd> lua require('telescope.builtin').find_files({hidden=true})<CR>]])
vim.keymap.set("n", "<leader>sb", [[<cmd> lua require('telescope.builtin').git_branches()<CR>]])
vim.keymap.set("n", "<leader>sB", [[<cmd> lua require('telescope.builtin').buffers()<CR>]])
vim.keymap.set("n", "<leader>sg", [[<cmd> lua require('telescope.builtin').live_grep()<CR>]])

-- LSP
vim.keymap.set("n", "<C-K>", "<cmd>lua require('metals').hover_worksheet()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")

vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")

-- temporary
vim.keymap.set("n", "<leader>oi", "<cmd>lua require('scalaimport').organize_imports()<CR>")
--#region
