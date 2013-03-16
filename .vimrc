set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'ervandew/supertab'
Bundle 'fugalh/desert.vim'
Bundle 'kien/ctrlp.vim'

" snipmate and dependencies
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/snipmate-snippets"
Bundle 'garbas/vim-snipmate'

Bundle 'majutsushi/tagbar'
Bundle 'airblade/vim-gitgutter'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-surround'

set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
filetype plugin indent on
 
syntax on
set number
set mouse=a
set mousehide

set hlsearch
set showmatch
set incsearch
set ignorecase
set nowrap
set autoindent
set history=1000
set cursorline
if has("unnamedplus")
  set clipboard=unnamedplus
elseif has("clipboard")
  set clipboard=unnamed
endif

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

" Nerdtree
autocmd vimenter * NERDTree
autocmd BufEnter * NERDTreeMirror
autocmd VimEnter * wincmd w
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0
 
set background=dark
colorscheme desert

" key remap
map  <c-l> :tabn<cr> 
map  <c-h> :tabp<cr> 
" map  <c-n> :tabnew<cr> 
nmap <silent> <leader>nt :NERDTreeToggle<CR>
" nmap <silent> <c-n> :NERDTreeToggle<CR>
map <leader>tb :TagbarToggle<cr>

" snipmate
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
