set guicursor=a:block-blinkon0
set nohlsearch
set hidden
set tabstop=4 softtabstop=4
set shiftwidth=4
set number
set relativenumber
set nowrap
set incsearch
set termguicolors
set scrolloff=8
set expandtab
set cursorline
set signcolumn=yes
set isfname+=@-@
set cmdheight=2
set updatetime=200
set colorcolumn=80,100,120
set formatoptions-=cro
set nowritebackup

set encoding=UTF-8
set clipboard+=unnamedplus

" {{{ --------------------- Plugins  ---------------------------------
call plug#begin('~/.config/nvim/plugged')

    Plug 'christoomey/vim-tmux-navigator'
    Plug 'morhetz/gruvbox'
    Plug 'geverding/vim-hocon'
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'lambdalisue/fern.vim'
    Plug 'lambdalisue/fern-hijack.vim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'powerline/powerline-fonts'
    Plug 'preservim/nerdcommenter'
    Plug 'ryanoasis/vim-devicons'
    Plug 'scalameta/coc-metals', {'do': 'yarn install --rfrozen-lockfile'}
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'vim-airline/vim-airline'
    "Plug 'ycm-core/YouCompleteMe'
    "Plug 'ycm-core/ycmd'

call plug#end()

colorscheme gruvbox
" --------------------------------------------------------------------}}}

" file specifics
autocmd FileType json syntax match Comment +\/\/.\+$+
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala
" au BufRead,BufNewFile *.conf set filetype=hocon

" Explorer preferences
let g:netrw_preview=1
let g:netrw_liststyle=3
let g:netrw_winsize=30

" Markdown features
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'scala']

" remaps
let mapleader=" "

nnoremap J :m +1<CR>
nnoremap K :m -2<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-c> <esc>
nnoremap <C-k> :call <SID>show_documentation()<CR>
" nnoremap <C-k> :help <c-r><c-w><CR>

" feels good, so why not
nnoremap <silent>- :Fern %:h<cr>
nnoremap <silent>_ :Fern .<cr>
nnoremap <silent>E :Fern . -drawer<cr>
nnoremap <leader><cr> :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>vrc :ex ~/.config/nvim/init.vim<CR>

" buffer remaps
nnoremap <silent> <leader>n :bn<cr>
nnoremap <silent> <leader>N :sbn<cr><c-w>L
nnoremap <silent> <leader>p :bp<cr>
nnoremap <silent> <leader>P :sbp<cr>
nnoremap <silent> <leader>bf :bf<cr>
nnoremap <silent> <leader>bl :bl<cr>
nnoremap <silent> <leader>B :Buffers<cr>
nnoremap <silent> <leader>wp :bwipeout<cr>

" fzf - Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
nmap <silent> <leader>F :Files<cr>
xmap <silent> <leader>F :Files<cr>
omap <silent> <leader>F :Files<cr>

" window naviation + tmux navigation
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <C-w>p :TmuxNavigatePrevious<cr>

function! s:show_documentation()
    if(index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

set list listchars=trail:.,extends:>
autocmd FileWritePre * call TrimWhiteSpace()
autocmd FileAppendPre * call TrimWhiteSpace()
autocmd FilterWritePre * call TrimWhiteSpace()
autocmd BufWritePre * call TrimWhiteSpace()

map <F2> :call TrimWhiteSpace()<CR>
map! <F2> :call TrimWhiteSpace()<CR>
" ----------------------- PLUGIN CONFIGS ------------------------------------ "
" airline
let g:airline_section_x = 0
let g:airline_section_y = 0
let g:airline_section_z = 0
set rtp+=~/.fzf

let NERDDefaultAlign='start'

" coc.nvim lsp mappings
"if filereadable(expand("~/.config/coc/extensions/node_modules/coc-metals/coc-mappings.vim"))
"    source ~/.config/coc/extensions/node_modules/coc-metals/coc-mappings.vim
"endif
if filereadable(expand("~/.config/nvim/coc-mappings.vim"))
    source ~/.config/nvim/coc-mappings.vim
endif

" remove the g flag from substitution
set nogdefault
