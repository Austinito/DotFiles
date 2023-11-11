local o = vim.o
local g = vim.g
local opt_global = vim.opt_global

o.cmdheight = 2
o.colorcolumn = "80,100,120"
o.cursorline = true
o.encoding = "UTF-8"
o.expandtab = true
o.hidden = true
o.hlsearch = false
o.incsearch = true
o.number = true
o.relativenumber = true
o.scrolloff = 8
o.shiftwidth = 4
o.signcolumn = "yes"
o.softtabstop = 4
o.tabstop = 4
o.termguicolors = true
o.updatetime = 200
o.wrap = false
o.writebackup = false

-- opt_global.shortmess:remove("F"):append("c")
opt_global.shortmess:append("c")
g.tmux_navigator_no_mappings = 1
g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'scala', 'lua' }
g.netrw_liststyle = 3
g.laststatus=3

g.python3_host_prog = '~/.virtualenvs/neovim-env/bin/python'
g.pymode_rope_lookup_project = 0
g.pymode_options_max_line_length = 120
