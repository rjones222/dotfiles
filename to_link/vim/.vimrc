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

" Use plugins config {{{
if filereadable(expand("~/.vimrc.plugins"))
    source ~/.vimrc.plugins
    syntax enable
    filetype plugin on
endif
" }}}

" Functions {{{

" adjust window height between min and max {{{
function! AdjustWindowHeight(minheight, maxheight)
    exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
" }}}

" Initialize directories {{{
function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }}}

" delete inactive buffers (the ones not in tabs or windows) {{{
" @link http://stackoverflow.com/a/7321131/557215
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Bdi :call DeleteInactiveBufs()
" }}}

" Strip whitespace {{{
function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
command! StripTrailingWhitespace :call StripTrailingWhitespace()<cr>
" }}}

" }}}

" Basics {{{
set hlsearch " Highlight search terms
set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize

" set quickfix window height min and max automatically
augroup quickfix_augroup
    autocmd!
augroup END
autocmd quickfix_augroup FileType qf call AdjustWindowHeight(3, 5)

set ttymouse=sgr " allow mouse to work after 233 columns

set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)
set splitright " Puts new vsplit windows to the right of the current
set splitbelow " Puts new split windows to the bottom of the current

set ignorecase " Case insensitive search
set smartcase " Case sensitive when uc present
set number " turn on line numbering

if has("mouse")
    set mouse=a " Automatically enable mouse usage
    set mousehide " Hide the mouse cursor while typing
endif
set shortmess+=filmnrxoOtT " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set history=1000 " Store a ton of history (default is 20)

" set noswapfile " pesky .swp files
" set nobackup

" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

" }}}
"
" Miscellaneous {{{

" if the last window is a quickfix, close it {{{
" au WinEnter * au! if winnr('$') == 1 && getbufvar(winbufnr(winnr()), '&buftype') == 'quickfix'|q|endif
augroup qfclose_augroup
    autocmd!
    autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END
" }}}

" fix split dragging in tmux {{{
if &term =~ '^screen'
    set ttymouse=xterm2
endif
" }}}

" undo {{{
if has('persistent_undo')
    set undofile " persistent undo
    set undolevels=1000 " Maximum number of changes that can be undone
    set undoreload=10000 " Maximum number lines to save for undo on a buffer reload
endif
" }}}

" use register that works with mac clipboard {{{
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
" }}}

" }}}

" Style {{{
" set background=dark
set cursorline
set colorcolumn=80
" silent! colorscheme lucius
silent! colorscheme molokayo
" silent! colorscheme badwolf
" }}}

" Mappings {{{

let g:mapleader = ',' " use comma for leader

" since , replaces leader, use \ to go back in a [f]ind
noremap \ ,

" Wrapped lines goes down/up to next row, rather than next line in file.
noremap j gj
noremap k gk

" Easier horizontal scrolling
map zl zL
map zh zH

" For when you forget to sudo.. Really Write the file.
cmap w!! w !sudo tee % >/dev/null

" my version of fast tabs
nnoremap gh gT
nnoremap gl gt

" use jj for exiting insert mode
inoremap jj <esc>

" vertical and horizontal splits like tmux
nnoremap <c-w>" :sp<cr>
nnoremap <c-w>% :vsp<cr>

" increment with c-b since I use c-a for tmux
nnoremap <c-b> <c-a>
vnoremap <c-b> <c-a>

" resize splits, consistent with tmux bindings
nnoremap <c-w><c-j> :resize +10<cr>
nnoremap <c-w><c-k> :resize -10<cr>
nnoremap <c-w><c-l> :vertical resize +10<cr>
nnoremap <c-w><c-h> :vertical resize -10<cr>

" put cursor at end of text on y and p
vnoremap <silent> y y`]
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" format all
 nnoremap <leader>fa mzggVG=`z :delmarks z<cr>hh :echo "formatted file"<cr>

" sort php use statements and come back
command! SortUse execute "normal! msgg/use\ <cr>vip:sort<cr>\`s:delmarks s<cr>:nohlsearch<cr>:echo 'sorted use statements'<cr>"
nnoremap <leader>su :SortUse<cr>

" map space to toggle folds
nnoremap <space> za
vnoremap <space> zf

" dotfile updates and private stuff updates {{{
if isdirectory(expand("~/.vim/plugged/vim-dispatch"))
    command! Dotupdates :Dispatch cd $HOME/.dotfiles && git add -A && git commit -am 'updates' && git push &&cd -
    command! Privateupdates :Dispatch cd $HOME/.private-stuff && git add -A && git commit -am 'updates' && git push &&cd -
    nnoremap <leader>tu :Dotupdates<cr>
    nnoremap <leader>tv :Privateupdates<cr>
endif
" }}}

" toggle search highlighting
nnoremap <silent> <leader>/ :nohlsearch<CR>

" open tag in tab
nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T

" open tag in vertical split
nnoremap <silent><Leader>v<C-]> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>

" open vhosts file
command! Vhost tabe /etc/apache2/extra/httpd-vhosts.conf

" source vimrc
command! Source :so $MYVIMRC

" show todos
if executable('ag') && isdirectory(expand("~/.vim/plugged/ag.vim"))
    nnoremap <leader>td :Ag! "todo"<CR>
    nnoremap <leader>tl :Ag! "todo"<CR>
endif

" Code folding options
nnoremap <leader>f0 :set foldlevel=0<CR>
nnoremap <leader>f1 :set foldlevel=1<CR>
nnoremap <leader>f2 :set foldlevel=2<CR>
nnoremap <leader>f3 :set foldlevel=3<CR>
nnoremap <leader>f4 :set foldlevel=4<CR>
nnoremap <leader>f5 :set foldlevel=5<CR>
nnoremap <leader>f6 :set foldlevel=6<CR>
nnoremap <leader>f7 :set foldlevel=7<CR>
nnoremap <leader>f8 :set foldlevel=8<CR>
nnoremap <leader>f9 :set foldlevel=9<CR>

" }}}

" Syntax highlighting and file types {{{
    " for those weird filetypes that need some help setting the correct filetype
    au BufRead,BufNewFile gulpfile set filetype=javascript
    au BufRead,BufNewFile Gulpfile set filetype=javascript
    au BufRead,BufNewFile *.html.twig set filetype=twig
    au BufRead,BufNewFile Vagrantfile set filetype=ruby

    " all front-end 2 space indents
    au FileType smarty,blade,html,javascript,json,css,twig,coffee,yaml,cucumber set et sw=2 ts=2
" }}}

" Gui {{{
if has("gui_running")
    set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h11
endif
" }}}

" Plugins {{{

" accelerated-smooth-scroll {{{
" only enable c-d and c-u. I don't use c-f and c-b and I want to use c-b
" for incrementing values.
if isdirectory(expand("~/.vim/plugged/accelerated-smooth-scroll"))
    let g:ac_smooth_scroll_no_default_key_mappings = 1
    nmap <silent> <C-d> <Plug>(ac-smooth-scroll-c-d)
    nmap <silent> <C-u> <Plug>(ac-smooth-scroll-c-u)
    xmap <silent> <C-d> <Plug>(ac-smooth-scroll-c-d_v)
    xmap <silent> <C-u> <Plug>(ac-smooth-scroll-c-u_v)
endif
" }}}

" {{{ ctrlp
if isdirectory(expand("~/.vim/plugged/ctrlp.vim"))
    " ctrlp extensions
    let g:ctrlp_extensions = ['tag']
    " alternate python matcher. 22x faster.
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    "nnoremap <leader>pb :CtrlPBuffer<CR>
    "nnoremap <leader>pm :CtrlPMRUFiles<CR>

    " ignore some dirs
    let g:ctrlp_custom_ignore = {
      \ 'dir':  'build',
      \ }
endif
" }}}

" {{{ fugitive
if isdirectory(expand("~/.vim/plugged/vim-fugitive"))
    let g:fugitive_github_domains = ['http://gitlab.prod.dm.local', 'https://git.github.com']

    nnoremap <silent> <leader>gs :Gstatus<CR>
    nnoremap <silent> <leader>gd :Gdiff<CR>
    nnoremap <silent> <leader>gc :Gcommit<CR>
    nnoremap <silent> <leader>gb :Gblame<CR>
    nnoremap <silent> <leader>gl :Glog<CR>
    " nnoremap <silent> <leader>gp :Git push<CR>
    nnoremap <silent> <leader>gr :Gread<CR>
    nnoremap <silent> <leader>gw :Gwrite<CR>
    nnoremap <silent> <leader>ge :Gedit<CR>
    " Mnemonic _i_nteractive
    nnoremap <silent> <leader>gi :Git add -p %<CR>
    nnoremap <silent> <leader>gg :SignifyToggle<CR>

    nnoremap <leader>gps :Dispatch! git push<CR>
    nnoremap <leader>gpu :Dispatch! git push<CR>
    nnoremap <leader>gpl :Dispatch! git pull<CR>:e<cr>
    nnoremap <leader>ga :Git add -A<CR><CR>
endif
" }}}"

" {{{ phpcomplete
if isdirectory(expand("~/.vim/plugged/phpcomplete.vim"))
    " phpcomplete omni complete for neocomplcache
    augroup phpcomplete_augroup
        autocmd!
    augroup END

    " only for php set the omnifunc to completephp
    autocmd phpcomplete_augroup FileType php set omnifunc=phpcomplete#CompletePHP

    " composer install command for phpcomplete
    let g:phpcomplete_relax_static_constraint = 1
    let g:phpcomplete_index_composer_command = "composer"
    let g:phpcomplete_parse_docblock_comments = 1
    let g:phpcomplete_cache_taglists = 1
    let g:phpcomplete_remove_function_extensions = ['xslt_php_4']
    let g:phpcomplete_remove_constant_extensions = ['xslt_php_4']
    " complete these built-in functions, classes, etc.
    " let g:phpcomplete_add_function_extensions = [...]
    " let g:phpcomplete_add_class_extensions = [...]
    " let g:phpcomplete_add_interface_extensions = [...]
    " let g:phpcomplete_add_constant_extensions = [...]

    " this avoids an error in php-cs-fixer.vim
    let g:phpcomplete_enhance_jump_to_definition = 0

    autocmd phpcomplete_augroup FileType php silent! nunmap <buffer> <unique> <C-]>
    autocmd phpcomplete_augroup FileType php silent! nunmap <buffer> <unique> <C-W><C-]>
    autocmd phpcomplete_augroup FileType php nnoremap <silent> <C-]> :<C-u>call phpcomplete#JumpToDefinition('normal')<CR>
    autocmd phpcomplete_augroup FileType php nnoremap <silent> <C-W><C-]> :<C-u>call phpcomplete#JumpToDefinition('split')<CR>
endif
" }}}"

" NERDCommenter {{{
if isdirectory(expand("~/.vim/plugged/nerdcommenter"))
    " extra space in NERDCommenter comments
    let g:NERDSpaceDelims="1"
endif
" }}}

" NERDTree {{{
if isdirectory(expand("~/.vim/plugged/nerdtree"))
    nnoremap <C-e> :NERDTreeMirrorToggle<CR>
    nnoremap <leader>nt :NERDTreeFind<CR>
    let NERDTreeShowHidden=1
    let NERDTreeMouseMode=2
    let NERDTreeQuitOnOpen=1
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
    let g:nerdtree_tabs_open_on_gui_startup=0
endif
" }}}

" {{{ PDV
" (php documentor for vim)
if isdirectory(expand("~/.vim/plugged/pdv"))
    let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
    nnoremap <buffer> <leader>pd :call pdv#DocumentWithSnip()<CR>
endif
" }}}

" {{{ phpctags
if isdirectory(expand("~/.vim/plugged/tagbar-phpctags.vim"))
    " phpctags
    let g:tagbar_phpctags_memory_limit = '512M'
endif
" }}}"

" {{{ promptline
if isdirectory(expand("~/.vim/plugged/promptline.vim"))
    " use airline extensions for promptline
    " let g:airline#extensions#promptline#enabled = 1
    let g:airline#extensions#promptline#enabled = 0
    let g:airline#extensions#promptline#snapshot_file = "~/.dotfiles/to_link/promptline.theme.bash"
    " let airline#extensions#promptline#color_template = 'normal'
    " let airline#extensions#promptline#color_template = 'insert'
    " let airline#extensions#promptline#color_template = 'visual'
    " let airline#extensions#promptline#color_template = 'replace'

    " easily save a snapshot of my current setup to my promptline file
    command! MyPromptline :PromptlineSnapshot! ~/.dotfiles/to_link/promptline.theme.bash

    " let g:promptline_theme = 'powerlineclone'
    " let g:promptline_theme = 'airline'
    let g:promptline_theme = 'airline_insert'
    " let g:promptline_theme = 'airline_visual'
    let g:promptline_preset = 'clear'
endif
" }}}"

" sessionman.vim {{{
if isdirectory(expand("~/.vim/plugged/sessionman.vim/"))
    nnoremap <Leader>sl :SessionList<CR>
    nnoremap <Leader>ss :SessionSave<CR>
    nnoremap <Leader>sc :SessionClose<CR>
endif
" }}}

" Syntastic {{{
if isdirectory(expand("~/.vim/plugged/syntastic"))
    " let g:syntastic_check_on_open=1

    " auto open loc list and jump to error when there's a php error
    let g:syntastic_auto_loc_list = 1

    " use npm package to check react scripts

    " spiffy error columns
    let g:syntastic_error_symbol='✗'
    let g:syntastic_warning_symbol='⚠'
    let g:syntastic_style_error_symbol='✗'
    let g:syntastic_style_warning_symbol='⚠'
endif
" }}}

" {{{ tagbar
if isdirectory(expand("~/.vim/plugged/tagbar"))
    " tagbar autofocus is the whole point of tagbar
    let g:tagbar_autofocus = 1
    let g:tagbar_autoclose = 1
    nnoremap <silent> <leader>tt :TagbarToggle<CR>
endif
" }}}

" {{{ tmuxline
if executable('tmux') && isdirectory(expand("~/.vim/plugged/tmuxline.vim"))
    command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.dotfiles/support/tmuxline.conf

    " use airline theme stuff when calling tmuxline
    " let g:airline#extensions#tmuxline#enabled = 1
    let g:airline#extensions#tmuxline#enabled = 0
    " let airline#extensions#tmuxline#color_template = 'insert'
    " let airline#extensions#tmuxline#color_template = 'visual'
    " let airline#extensions#tmuxline#color_template = 'replace'

    " let g:tmuxline_theme = 'airline'
    " let g:tmuxline_theme = 'airline_insert'
    " let g:tmuxline_theme = 'airline_visual'
    " let g:tmuxline_theme = 'iceberg'
    " let g:tmuxline_theme = 'jellybeans'
    " let g:tmuxline_theme = 'lightline'
    " let g:tmuxline_theme = 'lightline_insert'
    " let g:tmuxline_theme = 'lightline_visual'
    " let g:tmuxline_theme = 'nightly_fox'
    " let g:tmuxline_theme = 'powerline'
    " let g:tmuxline_theme = 'vim_powerline'
    " let g:tmuxline_theme = 'vim_statusline_1'
    " let g:tmuxline_theme = 'vim_statusline_2'
    let g:tmuxline_theme = 'vim_statusline_3'
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

" {{{ ultisnips
if isdirectory(expand("~/.vim/plugged/ultisnips"))
    let g:snips_author = 'Michael Funk <mike.funk@demandmedia.com>'
    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsListSnippets='<c-l>'


    " remap Ultisnips for compatibility for YCM
    let g:UltiSnipsExpandTrigger = '<C-j>'
    let g:UltiSnipsJumpForwardTrigger = '<C-j>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
endif
" }}}"

" {{{ undoclosewin
if isdirectory(expand("~/.vim/plugged/undoclosewin.vim"))
    " really it's undo close tab
    nnoremap <leader>uc :UcwRestoreWindow<cr>
endif
" }}}

" {{{ undotree
if isdirectory(expand("~/.vim/plugged/undotree"))
    silent! unmap <leader>u
    nnoremap <leader>uu :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
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

" {{{ vim-airline
if isdirectory(expand("~/.vim/plugged/vim-airline"))

    " airline use cool powerline symbols
    let g:airline_powerline_fonts=1

    if (isdirectory(expand("~/.vim/plugged/tagbar")))
        augroup php_tagbar
            autocmd!
        augroup END
        " warning php tagbar is really slow. So I only enabled it for php files.
        autocmd php_tagbar FileType php let g:airline#extensions#tagbar#enabled=1
        " change how tags are displayed (:help tagbar-statusline)
          " let g:airline#extensions#tagbar#flags = '' " (default)
          " let g:airline#extensions#tagbar#flags = 'f'
          " let g:airline#extensions#tagbar#flags = 's'
          " let g:airline#extensions#tagbar#flags = 'p'
    endif

    " advanced tabline vertical separators
    let g:airline#extensions#tabline#enabled = 1
endif

" }}}

" {{{ vim-indentline
if isdirectory(expand("~/.vim/plugged/indentLine"))
    " let g:indentLine_leadingSpaceEnabled = 1
    let g:indentLine_char = '┆'
endif
" }}}

" vim-json {{{
if isdirectory(expand("~/.vim/plugged/vim-json"))
    " turn off stupid no quotes in JSON except for current line
    let g:vim_json_syntax_conceal = 0
    " uh oh, it doesn't work well with indentLine plugin...
    " https://github.com/elzr/vim-json/issues/23#issuecomment-40293049
    let g:indentLine_noConcealCursor = ""
endif
" }}}

" vim-php-cs-fixer {{{
if isdirectory(expand("~/.vim/plugged/vim-php-cs-fixer"))
    " don't align phpdoc params, this could cause merge conflicts
    let g:php_cs_fixer_fixers_list = '-phpdoc_params'
endif
" }}}

" vim-php-manual {{{
if isdirectory(expand("~/.vim/plugged/vim-php-manual"))
    vnoremap <silent> <buffer> <S-K> y:call phpmanual#online#open(@@)<CR>
    nnoremap <silent> <buffer> <S-K> :call phpmanual#online#open()<CR>
endif
" }}}

" {{{ vim-php-namespace
if isdirectory(expand("~/.vim/plugged/vim-php-namespace"))
    " php add use statement for current class
    inoremap <Leader><Leader>u <C-O>:call PhpInsertUse()<CR>
    noremap <Leader><Leader>u :call PhpInsertUse()<CR>
endif
" }}}"

" vim-php-refactoring {{{
if isdirectory(expand("~/.vim/plugged/vim-php-refactoring")) && executable("refactor")
    let g:php_refactor_command='refactor'
endif
" }}}

" vim-plug {{{
nnoremap <leader>bi :so ~/.vimrc.plugins<cr> :PlugInstall<cr>
nnoremap <leader>bc :so ~/.vimrc.plugins<cr> :PlugClean!<cr>
nnoremap <leader>bu :so ~/.vimrc.plugins<cr> :PlugUpdate<cr>
" }}}

" {{{ vim-startify
if isdirectory(expand("~/.vim/plugged/vim-startify"))
    let g:startify_custom_header = [
            \ '                                 ________  __ __        ',
            \ '            __                  /\_____  \/\ \\ \       ',
            \ '    __  __ /\_\    ___ ___      \/___//''/''\ \ \\ \    ',
            \ '   /\ \/\ \\/\ \ /'' __` __`\        /'' /''  \ \ \\ \_ ',
            \ '   \ \ \_/ |\ \ \/\ \/\ \/\ \      /'' /''__  \ \__ ,__\',
            \ '    \ \___/  \ \_\ \_\ \_\ \_\    /\_/ /\_\  \/_/\_\_/  ',
            \ '     \/__/    \/_/\/_/\/_/\/_/    \//  \/_/     \/_/    ',
            \ '',
            \ '',
            \ ]

    let g:startify_session_dir = '~/.vim/sessions'
    " a list if files to always bookmark. Will be shown at bottom
    " of the startify screen.
    let g:startify_bookmarks = [ '~/.vimrc', '~/.vimrc.plugins' ]
    " always cd to git root on startup
    let g:startify_change_to_vcs_root = 1

    " disable common but unimportant files
    let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ '\.DS_Store'
        \ ]

    " make vim startify show recent files
    set viminfo='100,n$HOME/.vim/files/info/viminfo

    " autoload Session.vim in the current dir
    let g:startify_session_autoload = 1

    " auto save session on exit like obsession
    let g:startify_session_persistence = 1
endif
" }}}"

" {{{ vim-togglelist
if isdirectory(expand("~/.vim/plugged/vim-togglelist"))
    nnoremap <script> <silent> <leader>ll :call ToggleLocationList()<CR>
    nnoremap <script> <silent> <leader>qq :call ToggleQuickfixList()<CR>
endif
" }}}

" {{{ vim-autoclose
if isdirectory(expand("~/.vim/plugged/vim-autoclose"))
    " don't put closing "s in vimscript files
    let g:autoclose_vim_commentmode = 1
endif
" }}}

" {{{ vimux
if isdirectory(expand("~/.vim/plugged/vimux")) && executable('tmux')
    let g:VimuxHeight = "40"
    nnoremap <leader>vp :VimuxPromptCommand<cr>
    nnoremap <leader>vc :VimuxPromptCommand<cr>cd $PWD<cr>:VimuxInspectRunner<cr>
    nnoremap <leader>vl :VimuxRunLastCommand<cr>
    nnoremap <leader>vv :VimuxRunLastCommand<cr>
    nnoremap <leader>vr :VimuxRunLastCommand<cr>
    nnoremap <leader>vi :VimuxInspectRunner<cr>
    nnoremap <leader>vx :VimuxCloseRunner<cr>
    nnoremap <leader>vz :VimuxZoomRunner<cr>

    "nnoremap <leader>pf :VimuxPHPUnitRunCurrentFile<cr>
    "nnoremap <leader>pu :call VimuxRunCommand("phpunit")<cr>
    "nnoremap <leader>pp :VimuxRunLastCommand<cr>
endif
" }}}

" {{{ youcompleteme
if isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
    augroup youcompleteme_augroup
        autocmd!
    augroup END
    autocmd youcompleteme_augroup FileType css setlocal omnifunc=csscomplete#CompleteCSS

    " enable completion from tags
    let g:ycm_collect_identifiers_from_tags_files = 1

    " Enable omni completion.
    autocmd youcompleteme_augroup FileType css setlocal omnifunc=csscomplete#CompleteCSS
    autocmd youcompleteme_augroup FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
    autocmd youcompleteme_augroup FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    autocmd youcompleteme_augroup FileType python setlocal omnifunc=pythoncomplete#Complete
    autocmd youcompleteme_augroup FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
    autocmd youcompleteme_augroup FileType ruby setlocal omnifunc=rubycomplete#Complete

    " supposed to speed up ycm
    let g:ycm_register_as_syntastic_checker = 0

    " open preview window while completing
    let g:ycm_add_preview_to_completeopt=1

    " disable youcompleteme
    " let g:ycm_auto_trigger=0
    " let g:ycm_allow_changing_updatetime=0
    let g:ycm_seed_identifiers_with_syntax = 1
endif
" }}}

" {{{ ZoomWin
if isdirectory(expand("~/.vim/plugged/ZoomWin"))
    " mapping just like <c-a>z for tmux
    nnoremap <c-w>z :ZoomWin<cr>
endif
" }}}

" }}}
