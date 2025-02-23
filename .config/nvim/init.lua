----------------------------------
-- SETUP PLUGINS -----------------
----------------------------------
vim.cmd([[packadd packer.nvim]])
require("plugins")
require("sets")
local functions = require("settings.functions")
functions.load_configs("settings")
require("settings.cmp").setup()
require("settings.lsp").setup()
require("renamer").setup({})
-- vim.lsp.set_log_level('debug')

----------------------------------
-- CONFIGURE PLUGINS -------------
----------------------------------
functions.load_configs("configs")
vim.cmd("highlight DiagnosticError guifg=#FF0000 gui=bold")
vim.cmd("highlight DiagnosticWarn guifg=#FFD700 gui=italic")
vim.cmd("highlight NormalFloat guibg=#282C34 guifg=#5C6370")
vim.cmd("highlight FloatBorder guibg=#1E1E1E guifg=#C0C0C0")

------------------------------------
---- SETUP MAPPINGS ----------------
------------------------------------
require("remaps")

------------------------------------
---- COMMANDS ----------------------
------------------------------------
-- function to trim all trailing whitespace in the file without moving the cursor
vim.cmd([[function! TrimWhiteSpace()
  %s/\s*$//
  ''
  endfunction]])

-- Automatically trim trailing whitespace on save
vim.cmd("autocmd FileType * autocmd BufWritePre <buffer> call TrimWhiteSpace()")

-- when working with mardown files, we want wrap enabled.
vim.cmd("autocmd FileType markdown set wrap")

-- Automtically redraw status when there's a change in statusline
--vim.cmd("autocmd User StatusLine redrawstatus")

-- Toggle Autocompletion
vim.api.nvim_create_user_command('CmpToggle', function()
    require('cmp').setup.buffer { enabled = not require('cmp').config.enabled }
end, {})
--vim.api.nvim_create_user_command("ToggleAutocomplete", {
--  short_name = "tac",
--  nargs = 0,
--  cmd = "lua require('settings.functions').toggle_autocomplete()",
--})

------------------------------------
---- LAST MINUTE OVERRIDES ---------
------------------------------------
vim.cmd("set isfname+=@-@")
vim.cmd("set guicursor=a:block-blinkon0")
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("set formatoptions-=cro")
vim.cmd("let NERDDefaultAlign='start'")
vim.opt_global.shortmess:remove("F")

-- Theme stuff
vim.o.background = "dark" -- or "light"
vim.cmd("colorscheme gruvbox")

--require('solarized').set()

-- when working with mardown files, we want wrap enabled.
vim.cmd [[autocmd FileType markdown set wrap]]
