" Modeline and Notes {{{
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
"
"  ___  ____ _         ______           _
"  |  \/  (_) |        |  ___|         | |
"  | .  . |_| | _____  | |_ _   _ _ __ | | __
"  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
"  | |  | | |   <  __/ | | | |_| | | | |   <
"  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
"
" vimrc, finally free of spf13-vim!
" more info at http://mikefunk.com
" }}}

" General {{{

" Use plugins config {{{
if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
endif
" }}}

" sort php use statements and come back {{{
command! SortUse execute "normal! msgg/use\ <cr>vip:sort<cr>\`s:delmarks s<cr>:nohlsearch<cr>:echo 'sorted use statements'<cr>"
nnoremap <leader>su :SortUse<cr>
" }}}

" {{{ map space to toggle folds
nnoremap <space> za
vnoremap <space> zf
" }}}

" use comma for leader {{{
let g:mapleader = ','
" }}}

" dotfile updates and private stuff updates {{{
if isdirectory(expand("~/.vim/plugged/vim-dispatch"))
    command! Dotupdates :Dispatch cd $HOME/.dotfiles && git add -A && git commit -am 'updates' && git push &&cd -
    command! Privateupdates :Dispatch cd $HOME/.private-stuff && git add -A && git commit -am 'updates' && git push &&cd -
    nnoremap <leader>tu :Dotupdates<cr>
    nnoremap <leader>tv :Privateupdates<cr>
endif
" }}}

" Session List {{{
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
if isdirectory(expand("~/.vim/plugged/sessionman.vim/"))
    nnoremap <Leader>sl :SessionList<CR>
    nnoremap <Leader>ss :SessionSave<CR>
    nnoremap <Leader>sc :SessionClose<CR>
endif
" }}}

" }}}

" plugins {{{

" vim-airline {{{
if isdirectory(expand("~/.vim/plugged/vim-airline/"))
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_powerline_fonts=1
    let g:promptline_powerline_symbols = 1
endif
" }}}

" NERDTree {{{
if isdirectory(expand("~/.vim/plugged/nerdtree"))
    nnoremap <C-e> :NERDTreeMirrorToggle<CR>
    nnoremap <leader>nt :NERDTreeFind<CR>
endif
" }}}

" vim-plug {{{
nnoremap <leader>bi :so ~/.vimrc.plugins<cr> :PlugInstall<cr>
nnoremap <leader>bc :so ~/.vimrc.plugins<cr> :PlugClean!<cr>
nnoremap <leader>bu :so ~/.vimrc.plugins<cr> :PlugUpdate<cr>
" }}}

" }}}
