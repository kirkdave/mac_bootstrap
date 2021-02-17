" vim:fdm=marker

set nocompatible

" ===============================================
" Plugins
" ===============================================

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'rafi/awesome-vim-colorschemes'
Plug 'bling/vim-airline'
Plug 'godlygeek/tabular'

Plug 'hashivim/vim-terraform'

call plug#end()


" ===============================================
" Syntax Highlighting
" ===============================================

set t_Co=256
set background=dark
syntax on
colorscheme onedark


" ===============================================
" Map Leader
" ===============================================
let mapleader=","


" ===============================================
" Local Directories
" ===============================================

set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set undodir=~/.vim/undo


" ===============================================
" General / Misc Settings
" ===============================================

set autoindent
set backspace=indent,eol,start
set diffopt=filler            " keep the left and right aligned in diffs
set diffopt+=iwhite           " ingore whitespace changes in diffs
set encoding=utf-8 nobomb     " BOM can cause issues
set esckeys                   " Cursor keys in insert mode
set expandtab                 " Expand tabs to spaces
set shiftwidth=2              " The number of spaces for indenting
set softtabstop=2             " Tab will insert 2 spaces
set smarttab                  " At the start of a line, <tab> inserts `shiftwidth` spaces, <bs> deletes `shiftwidth` spaces
set mouse=a                   " Enable the mouse in all modes
set formatoptions+=c          " Format comments
set formatoptions+=r          " Continue comments by default
set formatoptions+=o          " Make comment when using o or O from comment line
set formatoptions+=q          " Format comments with gq
set formatoptions+=n          " Recognize numbered lists
set formatoptions+=2          " Use indent from 2nd line of a paragraph
set formatoptions+=l          " Don't break lines that are already long
set formatoptions+=1          " Break before 1-letter words
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive searches
set smartcase                 " Ignore the `ignorecase` if search pattern contains uppercase characters
set incsearch                 " Highlight matches as the pattern is typed
set laststatus=2              " Always show the status line
set lazyredraw
set modelines=0               " Disable modelines as a bit of a security precaution
set nomodeline
set noerrorbells
set nostartofline             " Don't put the cursor to the start of the line when moving around
set nowrap
set nu                        " Show line numbers
set ruler                     " Show the current cursor position
set shell=/usr/local/bin/bash " Use Homebrew bash to execute shell commands
set title                     " Show the filename in the window titlebar
set undofile                  " Persistent undo
set noshowmode                " Don't show the current mode (airline.vim takes care of us)


" ===============================================
" Airline
" ===============================================

augroup airline_config
  autocmd!
  let g:airline_powerline_fonts = 1
  let g:airline_enable_syntastic = 1
  let g:airline#extensions#tabline#buffer_nr_format = '%s '
  let g:airline#extensions#tabline#buffer_nr_show = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamecollapse = 0
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline_theme='one'
augroup END


" ===============================================
" Terraform
" ===============================================

augroup terraform_config
  autocmd!
  let g:terraform_align=1
  let g:terraform_fmt_on_save=1
augroup END
