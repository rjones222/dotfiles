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
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'vim-scripts/CSApprox'
Bundle 'jonathanfilip/vim-lucius'
Bundle 'joonty/vim-phpqa'
Bundle 'joonty/vim-phpunitqf'
Bundle 'joonty/vdebug.git'
Bundle 'majutsushi/tagbar'
Bundle 'airblade/vim-gitgutter'
Bundle 'mattn/zencoding-vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'tpope/vim-surround'
Bundle 'Lokaltog/powerline'
Bundle 'mileszs/ack.vim'
Bundle 'mattn/gist-vim'
Bundle 'benmills/vimux'
Bundle 'ChrisJohnsen/tmux-MacOSX-pasteboard'

" snipmate and dependencies
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/snipmate-snippets'
Bundle 'garbas/vim-snipmate'

" set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
filetype plugin indent on
 
syntax on
set number
set mouse=a
set mousehide
set colorcolumn=80

set hlsearch
set showmatch
set incsearch
set ignorecase
set nowrap
set autoindent
set history=1000
set cursorline
set listchars=tab:▸\ ,eol:¬
" if has("unnamedplus")
"   set clipboard=unnamedplus
" elseif has("clipboard")
"   set clipboard=unnamed
" endif

set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

set wildmenu
set wildmode=longest:full,full
set vb " visual bell
set hidden

" soft wrapping
command! -nargs=* Wrap set wrap linebreak nolist
vmap <D-j> gj
vmap <D-k> gk
vmap <D-4> g$
vmap <D-6> g^
vmap <D-0> g^
nmap <D-j> gj
nmap <D-k> gk
nmap <D-4> g$
nmap <D-6> g^
nmap <D-0> g^
set showbreak=↪

" Make Y behave like other capitals
nnoremap Y y$

" Nerdtree
" autocmd vimenter * NERDTree
" autocmd BufEnter * NERDTreeMirror
" autocmd VimEnter * wincmd w
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
" let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
" let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" theme
set background=dark
colorscheme lucius

" key remap
let mapleader = ","
map <c-l> :tabn<cr> 
map <c-h> :tabp<cr> 
map <c-n> :tabnew<cr> 
map <D-S-]> gt
map <D-S-[> gT
nmap <silent> <leader>nt :NERDTreeToggle<CR>
" nmap <silent> <c-n> :NERDTreeToggle<CR>
map <leader>tb :TagbarToggle<cr>
nmap <leader>l :set list!<CR>
nmap <leader>pl :!php -l %<cr>
nmap <leader>bpw :BreakpointWindow<cr>
nmap <leader>bpa :Breakpoint<cr>
nmap <leader>bpr :Breakpoint<cr>
" map <S-Enter> O<Esc>
" map <CR> o<Esc>
map <S-Enter> o<Esc>
inoremap jj <Esc>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%
nnoremap tw :tabclose<CR>
nnoremap tc :tabclose<CR>
nnoremap <Space> za

" powerline
set guifont=Menlo\ for\ Powerline:h12
let g:Powerline_symbols = 'compatible' " required by powerline
let g:Powerline_cache_enabled = 1
let g:Powerline_cache_file = expand('$TMP/Powerline.cache')
set t_Co=256    " required by powerline
set laststatus=2    " required by powerline
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" strip whitespace
if has("autocmd")
    autocmd BufWritePre *.css,*.js,*.php :call <SID>StripTrailingWhitespaces()
endif
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search and cursor position.
  let _s=@/
  let l = line(".")
  let c=col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" Source the vimrc file after saving it
" if has("autocmd")
"   autocmd bufwritepost .vimrc source $MYVIMRC
" endif

" Force Saving Files that Require Root Permission
cmap w!! %!sudo tee > /dev/null %

" vim-phpqa settings
let g:phpqa_messdetector_ruleset = "~/.vim/phpmd_ruleset.xml"
" Don't run messdetector on save (default = 1)
let g:phpqa_messdetector_autorun = 0
" Don't run codesniffer on save (default = 1)
let g:phpqa_codesniffer_autorun = 0

" snipmate php templates in html
au BufRead *.php set ft=php.html
au BufNewFile *.php set ft=php.html

" exuberant ctags - find closest parent tags file
set tags=./tags;/

" ===== theme color additions =====
hi LineNr guibg=#333639 guifg=#595D5F
hi SignColumn guibg=#333333
hi NonText guifg=#458BA5 guibg=#333333
hi SpecialKey guifg=#458BA5 guibg=#333333
hi ColorColumn guibg=black ctermbg=black
" set transparency=10

" vimux
" Prompt for a command to run
map <leader>rp :PromptVimTmuxCommand<cr>
" Run last command executed by RunVimTmuxCommand
map <leader>rl :RunLastVimTmuxCommand<cr>
" Inspect runner pane
map <leader>ri :InspectVimTmuxRunner<cr>
" Close all other tmux panes in current window
map <leader>rx :CloseVimTmuxPanes<cr>
" Interrupt any command running in the runner pane
map <leader>rs :InterruptVimTmuxRunner<cr>
