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

" use register that works with mac clipboard {{{
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
" }}}

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

" Style {{{
silent! colorscheme lucius
set background=dark
" }}}

" Plugins {{{

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

" {{{ tmuxline
if executable('tmux') && isdirectory(expand("~/.vim/plugged/tmuxline.vim"))
    command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.dotfiles/support/tmuxline.conf

    " use airline theme stuff when calling tmuxline
    " let g:airline#extensions#tmuxline#enabled = 1
    let g:airline#extensions#tmuxline#enabled = 0
    " let airline#extensions#tmuxline#color_template = 'insert'
    let airline#extensions#tmuxline#color_template = 'visual'
    " let airline#extensions#tmuxline#color_template = 'replace'

    let g:tmuxline_theme = 'airline'
    " let g:tmuxline_theme = 'airline_insert'
    " let g:tmuxline_theme = 'airline_visual'
    " let g:tmuxline_theme = 'powerline'
    " let g:tmuxline_theme = 'jellybeans'
    " let g:tmuxline_theme = 'zenburn'

    " let g:tmuxline_preset = 'full'
    " let g:tmuxline_preset = 'powerline'
    let g:tmuxline_preset = {
        \ 'a'    : ['❏ #S'],
        \ 'b'    : ['#H'],
        \ 'win'  : ['#I', '#W'],
        \ 'cwin' : ['#I', '#W#F'],
        \ 'x'    : ['#(battery -t)'],
        \ 'z'    : ['%a', '%b %d', '%I:%M %p'],
    \}
    let g:airline#extensions#tmuxline#snapshot_file = "~/.dotfiles/support/tmuxline.conf"
endif
" }}}

" {{{ vim-airline
if isdirectory(expand("~/.vim/plugged/vim-airline"))

    " warning php tagbar is really slow. So I only enabled it for php files.
    augroup php_tagbar
        autocmd!
    augroup END
    autocmd php_tagbar FileType php let g:airline#extensions#tagbar#enabled = 1
    autocmd php_tagbar FileType coffee let g:airline#extensions#tagbar#enabled = 1

    let g:airline#extensions#bufferline#enabled = 0

    " vim-bufferline prevent from showing in command bar *and* statusline
    let g:bufferline_echo = 0

    " advanced tabline vertical separators
    let g:airline#extensions#tabline#enabled = 1
endif

" }}}

" {{{ vdebug xdebug plugin
if isdirectory(expand("~/.vim/plugged/vdebug"))
    let g:vdebug_options = {}
    let g:vdebug_options['continuous_mode'] = 1
    let g:vdebug_options['timeout'] = 30
    let g:vdebug_options['server'] = '127.0.0.1'
    let g:vdebug_options['ide_key'] = 'netbeans-xdebug'
    " can add multiple path maps to this array, just duplicate the line
    " below and add another. remote is first, local is second.
    let g:vdebug_options['path_maps'] = {
    \   '/opt/igl': '/Users/mikefunk/sites/casesladder-repos/igl',
    \   '/opt/myleague': '/Users/mikefunk/sites/casesladder-repos/myleague'
    \}
    " stop on first line of execution
    " let g:vdebug_options["break_on_open"] = 0
    let g:vdebug_options["watch_window_style"] = 'compact'
    " move run_to_cursor from F1 to F9
    let g:vdebug_keymap = {
    \    "step_over" : "<F2>",
    \    "step_into" : "<F3>",
    \    "step_out" : "<F4>",
    \    "run" : "<F5>",
    \    "close" : "<F6>",
    \    "detach" : "<F7>",
    \    "run_to_cursor" : "<F9>",
    \    "set_breakpoint" : "<F10>",
    \    "get_context" : "<F11>",
    \    "eval_under_cursor" : "<F12>",
    \    "eval_visual" : "<Leader>ev",
    \}
endif
" }}}

" vim-plug {{{
nnoremap <leader>bi :so ~/.vimrc.plugins<cr> :PlugInstall<cr>
nnoremap <leader>bc :so ~/.vimrc.plugins<cr> :PlugClean!<cr>
nnoremap <leader>bu :so ~/.vimrc.plugins<cr> :PlugUpdate<cr>
" }}}

" }}}
