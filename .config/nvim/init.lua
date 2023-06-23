----------------------------------
-- SETUP PLUGINS -----------------
----------------------------------
vim.cmd([[packadd packer.nvim]])
require("plugins")
require("sets")
require("settings.cmp").setup()
require("settings.lsp").setup()
require("settings.statusline")
require("settings.functions")
require("flote").setup()

require("renamer").setup({})
--vim.lsp.set_log_level('trace')

----------------------------------
-- CONFIGURE PLUGINS -------------
----------------------------------
require("configs.treesitter")
require("configs.telescope")
vim.cmd("hi! StatusLine guifg=#5C6370 guibg=#282c34")
vim.cmd("hi! link StatusError DiagnosticError")
vim.cmd("hi! link StatusWarn DiagnosticWarn")
vim.opt.statusline = "%!luaeval('Austinito_custom_status_line()')"

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
vim.cmd("autocmd User StatusLine redrawstatus")

------------------------------------
---- LAST MINUTE OVERRIDES ---------
------------------------------------
vim.cmd("set isfname+=@-@")
vim.cmd("set guicursor=a:block-blinkon0")
vim.cmd("set clipboard+=unnamedplus")
vim.cmd("set formatoptions-=cro")
vim.cmd("let NERDDefaultAlign='start'")
vim.opt_global.shortmess:remove("F")
