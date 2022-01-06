" vim settings
set nocompatible              " be iMproved, required
set number relativenumber    " Enable Line Numbers
set cul               " highlight current line
set expandtab         " use spaces instead of tabs
colorscheme koehler   " Set Colorscheme
syntax on             " Enable syntax highlighting
filetype off          " filetype detection
set tabstop=2         " Set tab to 2 spaces
set shiftwidth=2
set backspace=indent,eol,start
set hlsearch
set laststatus=2
set noshowmode
set shell=/bin/bash
let mapleader = ","

" highlight color for paren
hi MatchParen cterm=bold ctermbg=none ctermfg=white

" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


" Folding 
set foldmethod=syntax " Syntax are used to specify folds"
set foldlevelstart=10

" plugins
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

if has('mac')
  " mac only plugins here
endif

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-eunuch'
Plug 'itchyny/lightline.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'wesQ3/vim-windowswap'

" Initialize plugin system
call plug#end()

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()


" Allow saving of files as sudo when I forget to start vim using sudo
cmap w!! w !sudo tee > /dev/null %

" keybindings
map <C-n> :NERDTreeToggle<CR>
" avoid crashes when calling vim-plug functions while the cursor is on the NERDTree window:
let g:plug_window = 'noautocmd vertical topleft new'
