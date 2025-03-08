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
vim.keymap.set("n", "<leader>e", "<cmd>Vexplore $PWD<CR>")

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
vim.keymap.set("n", "<leader>M", [[<cmd> lua require('telescope.builtin').marks()<CR>]])
vim.keymap.set("v", "<leader>sg", [[<cmd> lua require('telescope.builtin').grep_string()<CR>]])

-- LSP
vim.keymap.set("n", "<C-K>", "<cmd>lua require('metals').hover_worksheet()<CR>")
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")

vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>")
vim.keymap.set("n", "<leader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")

-- Terminal
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>")

-- temporary
vim.keymap.set("n", "<leader>oi", "<cmd>lua require('scalaimport').organize_imports()<CR>")
vim.keymap.set("n", "gp", "<cmd>silent %!prettier --stdin-filepath %<CR>")

-- harpoon (TODO: Let's find a way to elegantly handle this)
local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-h>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

--#region
