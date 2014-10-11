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

" From spf13-vim {{{

" Environment {{{

    " Identify platform {{{
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win16') || has('win32') || has('win64'))
        endfunction
    " }}}

    " Basics {{{
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }}}

    " Windows Compatible {{{
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }}}

" }}}

" Use plugins config {{{
    if filereadable(expand("~/..vimrc.plugins"))
        source ~/.vimrc.plugins
    endif
" }}}

" General {{{

    set background=dark         " Assume a dark background
    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    " Setting up the directories {{{
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " Add exclusions to mkview and loadview
        " eg: *.*, svn-commit.tmp
        let g:skipview_files = [
            \ '\[example pattern\]'
            \ ]
    " }}}

" }}}

" Vim UI {{{

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set nu                          " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }}}

" Formatting {{{

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }}}

" Key (re)Mappings {{{

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location.
    let mapleader = ','
    let maplocalleader = '_'

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases

    " Same for 0, home, end, etc
    function! WrapRelativeMotion(key, ...)
        let vis_sel=""
        if a:0
            let vis_sel="gv"
        endif
        if &wrap
            execute "normal!" vis_sel . "g" . a:key
        else
            execute "normal!" vis_sel . a:key
        endif
    endfunction

    " Map g* keys in Normal, Operator-pending, and Visual+select
    noremap $ :call WrapRelativeMotion("$")<CR>
    noremap <End> :call WrapRelativeMotion("$")<CR>
    noremap 0 :call WrapRelativeMotion("0")<CR>
    noremap <Home> :call WrapRelativeMotion("0")<CR>
    noremap ^ :call WrapRelativeMotion("^")<CR>
    " Overwrite the operator pending $/<End> mappings from above
    " to force inclusive motion with :execute normal!
    onoremap $ v:call WrapRelativeMotion("$")<CR>
    onoremap <End> v:call WrapRelativeMotion("$")<CR>
    " Overwrite the Visual+select mode mappings from above
    " to ensure the correct vis_sel flag is passed to function
    vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
    vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
    vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>

    " Stupid shift key fixes
    if has("user_commands")
        command! -bang -nargs=* -complete=file E e<bang> <args>
        command! -bang -nargs=* -complete=file W w<bang> <args>
        command! -bang -nargs=* -complete=file Wq wq<bang> <args>
        command! -bang -nargs=* -complete=file WQ wq<bang> <args>
        command! -bang Wa wa<bang>
        command! -bang WA wa<bang>
        command! -bang Q q<bang>
        command! -bang QA qa<bang>
        command! -bang Qa qa<bang>
    endif

    cmap Tabe tabe

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results.
    nmap <silent> <leader>/ :nohlsearch<CR>


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=expand('%:h').'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    nnoremap <silent> <leader>q gwip

" }}}

" Plugins {{{

    " Misc {{{
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            let g:NERDShutUp=1
        endif
        if isdirectory(expand("~/.vim/bundle/matchit.zip"))
            let b:match_ignorecase = 1
        endif
    " }}}

    " OmniComplete {{{
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif

        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " Some convenient mappings
        inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        if exists('g:spf13_map_cr_omni_complete')
            inoremap <expr> <CR>     pumvisible() ? "\<C-y>" : "\<CR>"
        endif
        inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " Automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }}}

    " Ctags {{{
        set tags=./tags;/,~/.vimtags

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }}}

    " AutoCloseTag {{{
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }}}

    " SnipMate {{{
        " Setting the author var
        let g:snips_author = 'Michael Funk <mike.funk@internetbrands.com>'
    " }}}

    " NerdTree {{{
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
        endif
    " }}}

    " Tabularize {{{
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /=<CR>
            vmap <Leader>a= :Tabularize /=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }}}

    " Session List {{{
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }}}

    " JSON {{{
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }}}

    " PyMode {{{
        " Disable if python support not present
        if !has('python')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/bundle/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }}}

    " ctrlp {{{
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            " On Windows use "dir" as fallback command.
            if WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            elseif executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}}}

    " TagBar {{{
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>

            " If using go please install the gotags program using the following
            " go install github.com/jstemmer/gotags
            " And make sure gotags is in your path
            let g:tagbar_type_go = {
                \ 'ctagstype' : 'go',
                \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
                    \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
                    \ 'r:constructor', 'f:functions' ],
                \ 'sro' : '.',
                \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
                \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
                \ 'ctagsbin'  : 'gotags',
                \ 'ctagsargs' : '-sort -silent'
                \ }
        endif
    "}}}


    " Fugitive {{{
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}}}

    " YouCompleteMe {{{
        let g:acp_enableAtStartup = 0

        " enable completion from tags
        let g:ycm_collect_identifiers_from_tags_files = 1

        " remap Ultisnips for compatibility for YCM
        let g:UltiSnipsExpandTrigger = '<C-j>'
        let g:UltiSnipsJumpForwardTrigger = '<C-j>'
        let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        " Disable the neosnippet preview candidate window
        " When enabled, there can be too much visual noise
        " especially when splits are used.
        set completeopt-=preview
    " }}}

    " Normal Vim omni-completion {{{
    " To disable omni complete, add the following to your .vimrc.before.local file:
        " Enable omni-completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
    " }}}

    " UndoTree {{{
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <Leader>uu :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }}}

    " indent_guides {{{
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }}}

    " Wildfire {{{
    let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }}}

    " vim-airline {{{

        " whether to user powerline fonts in vim-airline
        let g:airline_powerline_fonts=1

        " which airline theme to use
        let g:airline_theme='solarized'

        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline/"))
            if !exists('g:airline_theme')
                let g:airline_theme = 'solarized'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        endif
    " }}}

" }}}

" GUI Settings {{{

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }}}

" Functions {{{

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

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following to
        " your .vimrc.before.local file:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

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

    " Initialize NERDTree as needed {{{
    function! NERDTreeInitAsNeeded()
        redir => bufoutput
        buffers!
        redir END
        let idx = stridx(bufoutput, "NERD_tree")
        if idx > -1
            NERDTreeMirror
            NERDTreeFind
            wincmd l
        endif
    endfunction
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
    " }}}

    " Shell command {{{
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }}}

" }}}

" }}}

" My settings {{{

" General {{{
    let g:snips_author = 'Michael Funk <mike.funk@internetbrands.com>'

    " this allows you to run :checktime to update all open buffers
    set autoread
    autocmd CursorHold * checktime

    " this actively watches for changes and automatically updates files
    " changed externally in terminal vim. Works but it seems to load files
    " slower.
    " if filereadable($HOME . '/.dotfiles/support/watch_for_changes.vimrc.local')
        " source ~/.dotfiles/support/watch_for_changes.vimrc.local
        " let autoreadargs={'autoread':1}
        " silent execute WatchForChanges("*",autoreadargs)
    " endif

    " .md is markdown, not modula2
    au BufNewFile,BufRead *.md  setf markdown

    " supposed to speed syntax highlighting
    " set re=1

    " makes netrw look a little like a file drawer (not active since NERDTree
    " overrides netrw at the moment)
    let g:netrw_liststyle=3

    " Scratchpad from
    " http://dhruvasagar.com/2014/03/11/creating-custom-scratch-buffers-in-vim
    " usage:
    " :Sedit ft=php
    " :Stabedit ft=javascript
    function! ScratchEdit(cmd, options)
        exe a:cmd tempname()
        setl buftype=nofile bufhidden=wipe nobuflisted
        if !empty(a:options) | exe 'setl' a:options | endif
    endfunction

    " this is actually a plugin but they guy doesn't maintain or add to it so
    " there is no benefit to keeping it as a plugin. It's so small I'll just
    " put it here.
    command! VimuxPHPUnitRunCurrentFile :call s:VimuxPHPUnitRunCurrentFile()

    function! s:VimuxPHPUnitRunCurrentFile()
        call VimuxRunCommand('phpunit ' . expand('%:p'))
    endfunction

    " filter quickfix list with
    " :QFilter pattern " only show lines matching pattern
    " :QFilter pattern " hide lines matching pattern
    function! s:FilterQuickfixList(bang, pattern)
      let cmp = a:bang ? '!~#' : '=~#'
      call setqflist(filter(getqflist(), "bufname(v:val['bufnr']) " . cmp . " a:pattern"))
    endfunction
    command! -bang -nargs=1 -complete=file QFilter call s:FilterQuickfixList(<bang>0, <q-args>)

    command! -bar -nargs=* Sedit call ScratchEdit('edit', <q-args>)
    command! -bar -nargs=* Ssplit call ScratchEdit('split', <q-args>)
    command! -bar -nargs=* Svsplit call ScratchEdit('vsplit', <q-args>)
    command! -bar -nargs=* Stabedit call ScratchEdit('tabe', <q-args>)

    " select last paste in visual mode
    nnoremap <expr> gb '`[' . strpart(getregtype(), 0, 1) . '`]'

    " make searching with :find work sort-of like ctrlp
    set path=**
    set suffixesadd+=.php,.sh,.js,.less,.css,.coffee,.json

    " ag.vim equivalent with :grep searchterm
    set grepprg=ag\ --nocolor\ --nogroup\ --silent.
    " set grepprg=grep -nH

    " since , replaces leader, use \ to go back in a [f]ind
    noremap \ ,

    " {{{ fix split dragging in tmux
    set mouse+=a
    if &term =~ '^screen'
        " tmux knows the extended mouse mode
        set ttymouse=xterm2
    endif

    " allow mouse to work after 233 columns
    set ttymouse=sgr
    " }}}

    " {{{ format json
    nnoremap <leader>fj :%!python -m json.tool<cr>
    " }}}
    "
    " {{{ delete inactive buffers (the ones not in tabs or windows)
    " @link http://stackoverflow.com/a/7321131/557215
    function! DeleteInactiveBufs()
        "From tabpagebuflist() help, get a list of all buffers in all tabs
        let tablist = []
        for i in range(tabpagenr('$'))
            call extend(tablist, tabpagebuflist(i + 1))
        endfor

        "Below originally inspired by Hara Krishna Dara and Keith Roberts
        "http://tech.groups.yahoo.com/group/vim/message/56425
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

    " {{{ quickfix window
    " set quickfix window height min and max  automatically
    augroup quickfix_augroup
        " autocmd!
        autocmd FileType qf call AdjustWindowHeight(3, 5)
    augroup END

    function! AdjustWindowHeight(minheight, maxheight)
        exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
    endfunction
    " }}}"

    " {{{ change tab width
    function! MyTabWidth(fromwidth, towidth)
        " change every 4 spaces to a tab character
        exe "setlocal sw=".a:fromwidth." ts=".a:fromwidth." sts=".a:fromwidth." et"
        exe 'retab!'

        " change tab length to 2 spaces, expandtab, retab
        exe "setlocal sw=".a:towidth." ts=".a:towidth." sts=".a:towidth." et"
        exe 'retab'
    endfunction
    " }}}

    " {{{ Concept - load underlying class for Laravel
    function! FacadeLookup()
        let facade = input('Facade Name: ')
        let classes = {
\       'Eloquent': 'Database/Eloquent/Model.php'
\       'File': 'Filesystem/Filesystem.php',
\       'Form': 'Html/FormBuilder.php',
\       'Html': 'Html/HtmlBuilder.php',
\       'View': 'View/View.php',
\   }
        execute ":edit vendor/laravel/framework/src/Illuminate/" . classes[facade]
    endfunction
    nmap ,lf :call FacadeLookup()<cr>
    " }}}

    " {{{ Add a new dependency to a PHP class - doesn't work
    function! AddDependency()
        let dependency = input('Var Name: ')
        let namespace = input('Class Path: ')

        let segments = split(namespace, '\')
        let typehint = segments[-1]

        exec 'normal gg/construct^M:H^Mf)i, ' . typehint . ' $' . dependency . '^[/}^>O$this->^[a' . dependency . ' = $' . dependency . ';^[?{^MkOprotected $' . dependency . ';^M^[?{^MOuse ' . namespace . ';^M^['

        " Remove opening comma if there is only one dependency
        exec 'normal :%s/(, /(/g'
    endfunction
    " nmap <leader>2  :call AddDependency()<cr>
    " }}}

    " for mouseterm
    if has("mouse")
        set mouse=a
    endif

    " use php documentation with <shift>K from pear package pman"
    augroup phpman_autogroup
        autocmd FileType php set keywordprg=/Users/mfunk/pear/bin/pman\ -P\ less
        " autocmd FileType php nnoremap K :Silent pman <cword> <CR>
        " autocmd FileType php nnoremap K :Silent /usr/local/php5/bin/pman <cword> <CR>
        " autocmd FileType php nnoremap K <Plug>(phpcomplete-extended-doc)
    augroup END

    " enable matching of xml tags with %
    " runtime macros/matchit.vim

    " do not redraw while running macros - faster
    set lazyredraw

    " auto source vimrc
    " augroup vimrc_augroup
        " autocmd BufWritePost .vimrc.local,.vimrc.bundles.local,.vimrc.before.local,.vimrc.custom.local source $MYVIMRC
    " augroup END

    " allow interactive shell commands to source my .bash_profile
    " set shell=/bin/bash\ -i

    " disable auto folding
    set nofoldenable
    " and in PIV
    " let g:DisableAutoPHPFolding = 1

    " underline matching words automatically
    " hi WordMatch cterm=underline
    augroup highlight_augroup
        " autocmd!
        " autocmd CursorMoved * exe printf('match Underlined /\V\<%s\>/', escape(expand('<cword>'), '/\'))
    augroup END

    " enable the preview window for omnicompletion - doesn't work for some reason
    " set completeopt+=preview
    " set previewheight=15

    " supposed to make vim faster in tmux
    set notimeout
    set ttimeout
    set timeoutlen=50

    " also supposed to make vim faster
    " set nocursorline

    " turn off relative line numbering because it fucking sucks
    set nornu
    set number

    " disable spellcheck
    set nospell

    " Abbreviations
    abbrev pft PHPUnit_Framework_TestCase
    abbrev gm !php artisan generate:model
    abbrev gc !php artisan generate:controller
    abbrev gmig !php artisan generate:migration

    " if the last window is a quickfix, close it
    augroup qfclose_augroup
        " autocmd!
        autocmd WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
    augroup END

    " 2 space indent in front-end
    augroup highlight_augroup
        " autocmd!
        autocmd FileType smarty,blade,html,javascript,css,coffee :call Tab2()
    augroup END

    " sets everything to 2 spaces. For some reason just calling all this in
    " one line does not set shiftwidth, but sets the others fine.
    function! Tab2()
        setlocal shiftwidth=2
        setlocal tabstop=2
        setlocal softtabstop=2
        setlocal expandtab
    endfunction
" }}}

" Key Mapping {{{
    " soft wrapping
    command! -nargs=* Wrap set wrap linebreak nolist

    " close preview window with ,pp because I remap <c-w>z to zoom the window.
    " works like ,qq and ,ll except it can't re-open it of course
    nnoremap <leader>pp :pclose<cr>

    " paragraph nav I can remember - like unimpaired
    nnoremap [{ {j
    nnoremap ]} }k

    " sort use statements and come back
    command! SortUse execute "normal! msgg/use\ <cr>vip:sort<cr>\`s:delmarks s<cr>:nohlsearch<cr>"
    nnoremap <leader>su :SortUse<cr>

    " dotfile updates
    command! Dotupdates :Dispatch cd $HOME/.dotfiles && git add -A && git commit -am 'updates' && git push &&cd -

    " spf13-vim updates
    command! Spfupdate :Dispatch cd ~/.spf13-vim-3 && git pull && cd -

    " working commit
    command! Working :Dispatch cd $(git rev-parse --show-toplevel) && git add --all .; git commit -am "fixup!" && cd -

    " source vimrc
    command! Source :so $MYVIMRC

    " remove trailing spaces
    " command! StripTrailingWhitespace :%s/\s\+$//

    " covert dos line endings to unix line endings
    command! Dos2unix :%s///g
    command! Heming :%s///g

    " change tab width from 4 to 2 spaces and retab
    nnoremap <leader>t2 :call MyTabWidth(4,2)<cr>

    " change tab width from 2 to 4 spaces and retab
    nnoremap <leader>t4 :call MyTabWidth(2,4)<cr>

    " vertical and horizontal splits like tmux
    nnoremap <c-w>" :sp<cr>
    nnoremap <c-w>% :vsp<cr>

    " go to next/previous closed fold
    nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
    nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>

    " Vundle actions
    nnoremap <leader>bi :so $MYVIMRC<cr> :BundleInstall<cr>
    nnoremap <leader>bc :so $MYVIMRC<cr> :BundleClean!<cr>
    nnoremap <leader>bu :so $MYVIMRC<cr> :BundleUpdate<cr>

    " Clear all marks for the current buffer
    " nnoremap <leader>mc :delm! | delm A-Z0-9

    " function to use above key maps
    function! NextClosedFold(dir)
        let cmd = 'norm!z' . a:dir
        let view = winsaveview()
        let [l0, l, open] = [0, view.lnum, 1]
        while l != l0 && open
            exe cmd
            let [l0, l] = [l, line('.')]
            let open = foldclosed(l) < 0
        endwhile
        if open
            call winrestview(view)
        endif
    endfunction

    " {{{ foldmethod toggle between indent and marker
    let g:FoldMethod = 0
    nnoremap <leader>fm :call ToggleFold()<cr>
    fun! ToggleFold()
        if g:FoldMethod == 0
            exe 'set foldmethod=indent'
            exe 'set foldcolumn=4'
            let g:FoldMethod = 1
        else
            exe 'set foldmethod=marker'
            exe 'set foldcolumn=0'
            let g:FoldMethod = 0
        endif
    endfun
    " }}}

    " {{{ Laravel framework commons
    nmap <leader>lr :e app/routes.php<cr>
    nmap <leader>lca :e app/config/app.php<cr>81Gf(%O
    nmap <leader>lcd :e app/config/database.php<cr>
    nmap <leader>lc :e composer.json<cr>
    " }}}

    " {{{ map space to toggle folds
    nnoremap <space> za
    vnoremap <space> zf
    " }}}

    " open new lines without entering insert mode
    " just use unimpaired intead: ]<space> and [<space>
    " nnoremap <leader>o o<esc>
    " nnoremap <leader>O O<esc>

    " increment with c-b
    nnoremap <c-b> <c-a>
    vnoremap <c-b> <c-a>

    " copy all
    nnoremap <leader>ya mzggVGy`z :delmarks z<cr>h :echo "copied all text"<cr>

    " format all
    nnoremap <leader>fa mzggVG=`z :delmarks z<cr>h :echo "formatted file"<cr>

    " visually select a search result
    nnoremap g/ //e<Enter>v??<Enter>

    " my version of fast tabs
    nnoremap gh gT
    nnoremap gl gt
    nnoremap gn :tabnew<cr>
    2011
    2011

    " open tag in tab
    nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
    " open tag in vertical split
    nnoremap <silent><Leader>v<C-]> :vsp<CR>:exec("tag ".expand("<cword>"))<CR>

    " find all todos
    " noremap <Leader>td :noautocmd vimgrep /TODO/j **/*.php<CR>:cw<CR>

    " remap keys
    inoremap jj <Esc>

    " resize splits, consistent with tmux bindings
    nnoremap <c-w><c-j> :resize +10<cr>
    nnoremap <c-w><c-k> :resize -10<cr>
    nnoremap <c-w><c-l> :vertical resize +10<cr>
    nnoremap <c-w><c-h> :vertical resize -10<cr>

    " maximize split
    nnoremap <C-L> <C-W>l<C-W><bar>
    nnoremap <C-H> <C-W>h<C-W><bar>

    " open all buffers in new tabs
    " map <leader>bt :tab sball<CR>
    " map <leader>bt :bufdo tab split<CR>
    " let g:NERDTreeCustomReuseWindows = '1'
    " function! NERDTreeOpenAllInCurrentDirectory()
        " cd :BufOnly<CR>:args ./*.*<CR>:tab sball<CR>
    " endfunction
    " call NERDTreeAddKeyMap({
        " \ 'key': 'X',
        " \ 'scope': 'all',
        " \ 'callback': 'NERDTreeOpenAllInCurrentDirectory',
        " \ 'quickhelpText': 'Open all tags in current cd directory' })
    " doesn't work in NERDTree but that's where I want to use it
    " nnoremap <leader>bt cd :BufOnly<CR>:args ./*.*<CR>:tab sball<CR>
    nnoremap <leader>bo :BufOnly<cr>

    " open existing buffer in a newtab
    nnoremap <leader>te :ls<cr>:tabedit #

    " omnicompletion like Visual Studio or NetBeans
    " inoremap <C-Space> <C-x><C-o>
    " imap <C-@> <C-Space>

    " open link under cursor in browser
    nnoremap <leader>ou yiW:!open <c-r>" &<cr><cr>

    " {{{ put cursor at end of text on y and p
    vnoremap <silent> y y`]
    vnoremap <silent> p p`]
    nnoremap <silent> p p`]
    " }}}

" }}}

" Theme {{{

    set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h14
    " supposed to help colorschemes work better in 256 colors
    let g:rehash256 = 1

    " {{{ global powerline fonts switch is defined in .vimrc.before.local
        " let g:global_powerline_switch = 0

        if g:global_powerline_switch == 1
            let g:promptline_powerline_symbols = 1
            let g:tmuxline_powerline_separators = 1
            " let g:airline_powerline_fonts=1
            " let g:tmuxline_separators = {
                " \ 'left' : '',
                " \ 'left_alt': '',
                " \ 'right' : '',
                " \ 'right_alt' : '',
                " \ 'space' : ' '}
        else
            let g:promptline_powerline_symbols = 0
            let g:tmuxline_powerline_separators = 0
            " let g:airline_powerline_fonts=0
            let g:airline_left_sep = ''
            let g:airline_left_alt_sep = ''
            let g:airline_right_sep = ''
            let g:airline_right_alt_sep = ''
        endif
    " }}}

    " {{{ colorscheme
    if !exists('g:colorscheme_set')
        " colorscheme lucius
        colorscheme solarized
        " colorscheme badwolf
    endif
    let g:colorscheme_set = 1
    set background=light
    let g:solarized_contrast="normal"
    " let g:lucius_no_term_bg=1
    " solarized stuff I use
    " let g:solarized_termtrans=0
    " let g:solarized_termcolors=16
    " let g:solarized_diffmode="high"
    "
    " solariezed stuff I don't use
    " let g:solarized_degrade=0
    " let g:solarized_bold=1
    " let g:solarized_underline=1
    " let g:solarized_italic=1
    " let g:solarized_termcolors=16
    " let g:solarized_contrast="high"
    " let g:solarized_visibility="high"
    " let g:solarized_hitrail=1
    " let g:solarized_menu=1
    "
    " set fillchars="fold: "
    " }}}

    " {{{ set background based on time of day!
    " let hr = str2nr(strftime('%H'))
    " if hr <= 7
        " set background=dark
    " elseif hr <= 18
        " set background=light
    " else
        " set background=dark
    " endif
    " }}}

    " {{{ custom indent guide colors
    set colorcolumn=80
    " augroup indent_guides_augroup
        " autocmd!
        " autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd ctermbg=black
        " autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=black
    " augroup END
    " }}}

    " {{{ toggle between day and night theme
    " silent call togglebg#map("<leader>bg")
    nnoremap <leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>
    " }}}

    " {{{ change the default EasyMotion shading to something more readable with Solarized
    hi link EasyMotionTarget ErrorMsg
    hi link EasyMotionShade  Comment
    " }}}

    " {{{ vim-gitgutter better background
    " highlight clear SignColumn
    " hi link SignColumn LineNr
    " }}}

    " {{{ syntax highlighting for Vagrantfile
    augroup vagrant
        au!
        au BufRead,BufNewFile Vagrantfile set filetype=ruby
    augroup END
    " }}}

" }}}

" Plugins {{{

    " accelerated-smooth-scroll {{{
    " only enable c-d and c-u. I don't use c-f and c-b and I want to use c-b
    " for incrementing values.
    let g:ac_smooth_scroll_no_default_key_mappings = 1
    nmap <silent> <C-d> <Plug>(ac-smooth-scroll-c-d)
    nmap <silent> <C-u> <Plug>(ac-smooth-scroll-c-u)
    xmap <silent> <C-d> <Plug>(ac-smooth-scroll-c-d_v)
    xmap <silent> <C-u> <Plug>(ac-smooth-scroll-c-u_v)
    " }}}

    " {{{ Colorizer
    let g:colorizer_auto_filetype='css,scss,less,sass'
    " }}}

    " cosco.vim {{{
    augroup cosco_vim_augroup
        autocmd FileType javascript,css,php nnoremap <silent> <leader>; :call cosco#commaOrSemiColon()<CR>
        autocmd FileType javascript,css,php inoremap <silent> <leader>; <ESC>:call cosco#commaOrSemiColon()"<CR>a
    augroup END
    " }}}

    " {{{ ctrlp
    " ctrlp extensions
    let g:ctrlp_extensions = ['tag']
    " alternate python matcher. 22x faster.
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    nnoremap <leader>pb :CtrlPBuffer<CR>
    nnoremap <leader>pm :CtrlPMRUFiles<CR>

    " ignore some dirs
    let g:ctrlp_custom_ignore = {
      \ 'dir':  'build',
      \ }
    " }}}"

    " {{{ dispatch
    nnoremap <silent> <Leader>di :call CallDispatchWithCommand() <CR>

    function! CallDispatchWithCommand()
      let dispatch_command = input('> ')
      execute ':Dispatch ' . dispatch_command
    endfunction
    " }}}

    " {{{ easytags
    " easytags just doesn't work well. it blocks the ui when updating (doesn't
    " use dispatch), it doesn't use my custom easy_tags_cmd, and the
    " highlighting won't use my custom highlight. Fuck it, we'll do it live!
    nnoremap <silent> <Leader>ut :silent Dispatch! echo 'exporting ctags...' && cd $(git rev-parse --show-toplevel) && ctags -R --exclude=.git --exclude='*.log' --fields=+aimSl --languages=php --PHP-kinds=+cf --sort=foldcase<CR>

    " Easytags blocks the UI on pause, which sucks! It also apparently
    " slows down the UI with it's highlighting, which I can't seem to switch
    " to underlining anyway. What is a better solution? In the mean time I
    " map to update manually with ,ct.
    " let g:easytags_auto_update = 0
    " let g:easytags_dynamic_files=1
    " let g:easytags_updatetime_warn=0
    " let g:easytags_python_enabled=1
    " let b:easytags_auto_highlight=0
    " nnoremap <Leader>ut :UpdateTags<CR>

    " this doesn't work. Apparently it's only for the path to ctags, not args.
    " let g:easytags_cmd="ctags -R --exclude=.git --exclude=*.log --exclude=*.js --fields=+aimS --languages=php --PHP-kinds=+cf --recurse=yes --tag-relative=yes 2>/dev/null"

    " this doesn't seem to work, it just disables highlighting. I can't figure
    " out why.
    " highlight phpFunctionsTag cterm=underline gui=underline term=underline
    " highlight phpClassesTag cterm=underline gui=underline term=underline
    " }}}

    " {{{ vim-fold-expr
    " let b:phpfold_doc_with_funcs = 0
    " }}}

    " {{{ fugitive
    let g:fugitive_github_domains = ['https://gitlab.git.internetbrands.com', 'https://git.github.com']
    " filename
    hi default link User1 Identifier"blue
    " flags
    hi default link User2 Statement"green
    " errors
    hi default link User3 Error"orange
    " fugitive
    hi default link User4 Special

    augroup fugitive_augroup
        " autocmd!
        " reset file to HEAD in fugitive commit window
        autocmd FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
        " open quickfix window on git grep
        autocmd QuickFixCmdPost *grep* cwindow
    augroup END

    " Fugitive Commands
    command! -bar -nargs=* Gpull execute 'Git pull' <q-args> 'origin' fugitive#head()
    command! -bar -nargs=* Gpush execute 'Git push' <q-args> 'origin' fugitive#head()
    command! -bar -nargs=* Gpurr execute 'Git pull --rebase' <q-args> 'origin' fugitive#head()
    command! Gpnp silent Gpull | Gpush
    command! Gprp silent Gpurr | Gpush
    command! Gsync :Dispatch git checkout develop && git pull && git checkout - && git merge develop
    command! Gnuke silent execute 'Git reset --hard'

    silent! unmap <leader>gp
    " nnoremap <silent> <leader>gpu :Gpuspacesh<CR>
    " nnoremap <silent> <leader>gpl :Gpull<CR>:e<CR>
    nnoremap <Leader>g- :Silent Git stash<CR>:e<CR>
    nnoremap <Leader>g+ :Silent Git stash pop<CR>:e<CR>
    nnoremap <leader>gn :Gnuke<cr>
    nnoremap <leader>gps :Dispatch! git push<CR>
    nnoremap <leader>gpu :Dispatch! git push<CR>
    nnoremap <leader>gpl :Dispatch! git pull<CR>:e<cr>
    " }}}"

    " {{{ gitv
    " browser mode
    nnoremap <Leader>gv :Gitv --all<CR>

    " file mode
    nnoremap <Leader>gV :Gitv! --all<CR>
    vnoremap <leader>gV :Gitv! --all<cr>

    " easily perform arbitrary git commands
    cabbrev git Git

    " automatically split in whatever direction fits best
    let g:Gitv_OpenHorizontal = 'auto'

    " breaks ctrl-p and multiple cursors
    let g:Gitv_DoNotMapCtrlKey = 1

    " up/down commit nav
    " doesn't work
    " nnoremap <silent> <leader>gn :<C-U>call <SID>JumpToCommit(0)<cr>
    " nnoremap <silent> <leader>gp :<C-U>call <SID>JumpToCommit(1)<cr>
    " }}}
    "
    " matchit {{{
    augroup blade_html_features
        " autocmd!
        " get the best of all worlds
        au FileType blade set ft=html | set syntax=blade | let b:match_debug=1
    augroup END
    " }}}

    " NERDTree {{{
        let NERDTreeIgnore=['\.DS_Store$', '\.vim$']
        " extra space in NERDCommenter comments
        let g:NERDSpaceDelims="1"

        augroup NERDTreeCustomizations
            " If I don't do this then signature overwrites my nerdtree menu map
            autocmd!
            autocmd FileType nerdtree nnoremap <buffer> <nowait> m :call nerdtree#ui_glue#invokeKeyMap("m")<CR>
        augroup END

        " NERDTree expand dirs with one child
        " let NERDTreeCasadeOpenSingleChildDir=1

        " NERDTree change keyboard shortcuts to use vim-nerdtree-tabs
        " map <C-e> :NERDTreeTabsToggle<CR>:NERDTreeMirrorOpen<CR>
        " map <C-e> :NERDTreeTabs<CR>:NERDTreeMirrorOpen<CR>
        " map <C-e> :NERDTreeTabsToggle<CR>
        map <C-e> :NERDTreeMirrorToggle<CR>

        " don't open a split for ctrlp or nerdtree
        augroup startify_augroup
            " autocmd!
            autocmd FileType startify setlocal buftype=
        augroup END
    " }}}

    " {{{ neocomplcache

    " neocomplcache disable auto popup
    " let g:neocomplcache_disable_auto_complete = 1

    " c-j and c-k go down and up in the list for neocomplcache
    " inoremap <expr> <C-j> pumvisible() ? '\<C-n>' : '\<C-j>'
    " inoremap <expr> <C-k> pumvisible() ? '\<C-p>' : '\<C-k>'
    " }}}"

    " {{{ openbrowser.vim
    " Open URI under cursor.
    nmap <leader>gu <Plug>(openbrowser-open)

    " Open selected URI.
    vmap <leader>gu <Plug>(openbrowser-open)
    " }}}

    " {{{ PDV
    " PDV comment parameters
    let g:pdv_cfg_Package   = "Example"
    let g:pdv_cfg_Author    = "Michael Funk <mike.funk@internetbrands.com>"
    let g:pdv_cfg_Copyright = "Copyright 2013 Internet Brands, Inc. All Rights Reserved."
    let g:pdv_cfg_License   = ""
    let g:pdv_cfg_Version   = ""
    let g:pdv_cfg_ClassTags = ["author"]
    " }}}"

    " {{{ phpcomplete
    " phpcomplete omni complete for neocomplcache
    augroup phpcomplete_augroup
        " autocmd!
        " autocmd BufNewFile,BufRead *.twig,*.blade.php,*.tpl set filetype=html
        " autocmd BufNewFile,BufRead *.twig,*.blade.php,*.tpl,*.css,*.js,*.html set ts=2 sw=2 sts=2
        " autocmd FileType php set omnifunc=phpcomplete_extended#CompletePHP
        autocmd FileType php set omnifunc=phpcomplete#CompletePHP
    augroup END

    " composer install command for phpcomplete
    let g:phpcomplete_relax_static_constraint = 1
    let g:phpcomplete_index_composer_command = "composer"
    let g:phpcomplete_parse_docblock_comments = 1
    let g:phpcomplete_cache_taglists = 1
    let g:phpcomplete_remove_function_extensions = ['xslt_php_4']
    let g:phpcomplete_remove_constant_extensions = ['xslt_php_4']

    " this avoids an error in php-cs-fixer.vim
    let g:phpcomplete_enhance_jump_to_definition = 0
    silent! nunmap <buffer> <unique> <C-]>
    silent! nunmap <buffer> <unique> <C-W><C-]>
    nnoremap <silent> <C-]> :<C-u>call phpcomplete#JumpToDefinition('normal')<CR>
    nnoremap <silent> <C-W><C-]> :<C-u>call phpcomplete#JumpToDefinition('split')<CR>
    " }}}"

    " {{{ phpctags
    " phpctags
    let g:tagbar_phpctags_memory_limit = '512M'
    " }}}"

    " {{{ phpdoc
    augroup phpdoc_augroup
        autocmd!
        au BufRead,BufNewFile *.php inoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
        au BufRead,BufNewFile *.php nnoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
        au BufRead,BufNewFile *.php vnoremap <buffer> <leader>pd :call PhpDocRange()<CR>
    augroup END
    " }}}"

    " {{{ promptline

    " use airline extensions for promptline
    " let g:airline#extensions#promptline#enabled = 1
    let g:airline#extensions#promptline#enabled = 0
    let g:airline#extensions#promptline#snapshot_file = "~/.dotfiles/to_link/promptline.theme.bash"
    " let airline#extensions#promptline#color_template = 'insert'
    " let airline#extensions#promptline#color_template = 'visual'
    let airline#extensions#promptline#color_template = 'replace'

    " easily save a snapshot of my current setup to my promptline file
    command! MyPromptline :PromptlineSnapshot! ~/.dotfiles/to_link/promptline.theme.bash

    " snapshot promptline and tmuxline configs in one command
    function! MyConfigs()
        :MyPromptline
        :MyTmuxline
    endfunction
    command! MyConfFiles :call MyConfigs()

    " let g:promptline_theme = 'powerlineclone'
    " let g:promptline_theme = 'airline'
    let g:promptline_theme = 'airline_insert'
    " let g:promptline_theme = 'airline_visual'
    let g:promptline_preset = 'clear'
    " }}}"

    " sunset {{{
    let g:sunset_utc_offset = -8
    let g:sunset_latitude = 33.930324
    let g:sunset_longitude = -118.395538
    " }}}

    " Syntastic {{{
    " let g:syntastic_check_on_open=1
    let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['html'] }

    " underlining errors slows it down, it's in the sidebar already
    " let g:syntastic_enable_highlighting = 0
    let g:syntastic_php_phpmd_post_args = '~/.dotfiles/support/phpmd_ruleset.xml'
    let g:syntastic_php_phpcs_args='--report=csv --standard=psr2'
    " let g:syntastic_enable_signs = 1

    " auto open loc list and jump to error when there's a php error
    let g:syntastic_auto_loc_list = 1
    " let g:syntastic_always_populate_loc_list = 1
    " let g:syntastic_debug = 17
    " let g:syntastic_debug = 3
    " let g:syntastic_auto_jump = 2
    " let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
    " phpmd is kind of useless to me right now
    let g:syntastic_php_checkers = ['php', 'phpcs']

    " spiffy error columns
    let g:syntastic_error_symbol='✗'
    let g:syntastic_warning_symbol='⚠'
    let g:syntastic_style_error_symbol='✗'
    let g:syntastic_style_warning_symbol='⚠'
    " }}}

    " {{{ tabular
    nmap <leader>a> :Tabularize /=><cr>
    vmap <leader>a> :Tabularize /=><cr>
    " }}}"

    " {{{ tagbar
    " tagbar autofocus is the whole point of tagbar
    let g:tagbar_autofocus = 1
    let g:tagbar_autoclose = 1
    " let g:tagbar_autopreview = 1

    " enable css ctags
    let g:tagbar_type_css = {
    \ 'ctagstype' : 'Css',
        \ 'kinds'     : [
            \ 'c:classes',
            \ 's:selectors',
            \ 'i:identities'
        \ ]
    \ }
    " }}}"

    " {{{ tasklist
    " tasklist plugin
    " let g:tlTokenList = ['@TODO', '@FIXME']
    " let g:tlWindowPosition = 1
    " nnoremap <leader>td :TaskList<CR>
    " nnoremap <leader>tl :TaskList<CR>
    nnoremap <leader>td :Ag "todo"<CR>:cw<CR>
    nnoremap <leader>tl :Ag "todo"<CR>:cw<CR>
    " }}}"

    " {{{ tmuxline
    command! MyTmuxline :Tmuxline | TmuxlineSnapshot! ~/.dotfiles/support/tmuxline.conf

    " use airline theme stuff when calling tmuxline
    " let g:airline#extensions#tmuxline#enabled = 1
    let g:airline#extensions#tmuxline#enabled = 0
    " let airline#extensions#tmuxline#color_template = 'insert'
    " let airline#extensions#tmuxline#color_template = 'visual'
    let airline#extensions#tmuxline#color_template = 'replace'

    " let g:tmuxline_theme = 'airline'
    " let g:tmuxline_theme = 'airline_insert'
    let g:tmuxline_theme = 'airline_visual'
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
    " }}}

    " {{{ ultisnips
    " ultisnips start with my ultisnips
    " let g:UltiSnipsSnippetDirectories=['UltiSnips', 'ultisnips_snippets']
    let g:UltiSnipsDontReverseSearchPath="1"
    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsListSnippets='<c-l>'
    " let g:UltiSnipsExpandTrigger='<a-;>'
    " let g:UltiSnipsJumpForwardTrigger='<c-l>'
    " let g:UltiSnipsJumpBackwardTrigger='<c-h>'
    " let g:UltiSnips#ExpandSnippetOrJump='<a-;>'
    " }}}"

    " {{{ underline tags
    " augroup UnderlineTag
      " autocmd!
      " autocmd BufEnter *.php UnderlineTagOn
    " augroup END
    " }}}

    " {{{ undoclosewin
    " really it's undo close tab
    nnoremap <leader>uc :UcwRestoreWindow<cr>
    " }}}

    " {{{ undotree
    silent! unmap <leader>u
    nnoremap <leader>uu :UndotreeToggle<CR>
    " }}}

    " {{{ vdebug xdebug plugin
    let g:vdebug_options = {}
    let g:vdebug_options["continuous_mode"] = 1
    let g:vdebug_options["timeout"] = 30
    let g:vdebug_options['server'] = '192.168.56.1'
    let g:vdebug_options['port'] = '9000'
    let g:vdebug_options['ide_key'] = 'netbeans-xdebug'
    let g:vdebug_options['path_maps'] = {'/var/www': '/Users/mfunk/Sites'}
    " stop on first line of execution
    let g:vdebug_options["break_on_open"] = 0
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
    " }}}"

    " {{{ vim-activity-log
    let g:activity_log_location = '~/.vim/activity/%Y/%m/%d.log'
    " }}}

    " {{{ vim-airline
    " use short form mode indicators
    " let g:airline_mode_map = {
        " \ '__' : '-',
        " \ 'n'  : 'N',
        " \ 'i'  : 'I',
        " \ 'R'  : 'R',
        " \ 'c'  : 'C',
        " \ 'v'  : 'V',
        " \ 'V'  : 'V',
        " \ '' : 'V',
        " \ 's'  : 'S',
        " \ 'S'  : 'S',
        " \ '' : 'S',
        " \ }

    " let g:airline_theme = 'solarized'
    " warning this is really slow. So I only enabled it for php files.
    augroup php_tagbar
        autocmd FileType php let g:airline#extensions#tagbar#enabled = 1
    augroup END
    " moved to global powerline switch above
    " let g:airline_left_sep = ''
    " let g:airline_left_alt_sep = ''
    " let g:airline_right_sep = ''
    " let g:airline_right_alt_sep = ''

    " unicode symbols
    " let g:airline_left_sep = '»'
    " let g:airline_left_sep = '▶'
    " let g:airline_right_sep = '«'
    " let g:airline_right_sep = '◀'
    " let g:airline_symbols.linenr = '␊'
    " let g:airline_symbols.linenr = '␤'
    " let g:airline_symbols.linenr = '¶'
    " let g:airline_symbols.branch = '⎇'
    " let g:airline_symbols.paste = 'ρ'
    " let g:airline_symbols.paste = 'Þ'
    " let g:airline_symbols.paste = '∥'
    " let g:airline_symbols.whitespace = 'Ξ'
    " let g:airline_powerline_fonts = 1
    " moved to global powerline switch above
    " let g:airline_powerline_fonts=0
    " let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#bufferline#enabled = 0
    " vim-bufferline prevent from showing in command bar *and* statusline
    let g:bufferline_echo = 0

    " unicode symbols
    " let g:airline_left_sep = '»'
    " let g:airline_left_sep = '▶'
    " let g:airline_right_sep = '«'
    " let g:airline_right_sep = '◀'
    " let g:airline_symbols.linenr = '␊'
    " let g:airline_symbols.linenr = '␤'
    " let g:airline_symbols.linenr = '¶'
    " let g:airline_symbols.branch = '⎇'
    " let g:airline_symbols.paste = 'ρ'
    " let g:airline_symbols.paste = 'Þ'
    " let g:airline_symbols.paste = '∥'
    " let g:airline_symbols.whitespace = 'Ξ'

    " advanced tabline vertical separators
    " let g:airline#extensions#tabline#enabled = 1
    " let g:airline#extensions#tabline#left_sep = ' '
    " let g:airline#extensions#tabline#left_alt_sep = '|'
    " let g:airline#extensions#tabline#left_alt_sep = ' '

    " }}}

    " {{{ vim-ctrlp-tjump
    " nnoremap <c-]> :CtrlPtjump<cr>
    " let g:ctrlp_tjump_only_silent = 1
    " vnoremap <c-]> :CtrlPtjumpVisual<cr>
    " }}}"

    " vim-easyclip {{{
    let g:EasyClipAutoFormat = 1
    let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
    " }}}

    " {{{ vim-github-dashboard
    let g:github_dashboard = { 'username': 'mikedfunk' }
    " }}}

    " {{{ vim-indent-guides
    " let g:indent_guides_guide_size=4

    " plugin does a crappy job of defining low-contrast indent guide colors
    " for terminal vim. this is really annoying but at least I only have to
    " find the best colors once per color scheme.

    " define a function to change the indent guide color highlights based
    " on background color
    function! SetIndentGuideColors()
        " none of this stuff works if gui is running
        if !has('gui_running')
            if g:colors_name == 'lucius'
                let g:indent_guides_auto_colors = 0
                if &background == 'light'
                    hi IndentGuidesOdd ctermbg=7
                    hi IndentGuidesEven ctermbg=7
                else
                    " lighter than even
                    hi IndentGuidesOdd ctermbg=238
                    " slightly darker than bg variant
                    " hi IndentGuidesOdd ctermbg=235
                    hi IndentGuidesEven ctermbg=237
                endif
            elseif g:colors_name == 'solarized'
                let g:indent_guides_auto_colors = 0
                if &background == 'light'
                    " let g:vim_search_pulse_color_list = [220, 214, 208, 202, 196]
                    " let g:vim_search_pulse_color_list = [214, 214, 214, 214, 214]
                    " let g:vim_search_pulse_color_list = [40, 34, 28, 22, 16]
                    let g:vim_search_pulse_color_list = [220, 214, 214, 214, 214]
                    call search_pulse#initialize()
                    hi IndentGuidesOdd ctermbg=7
                    hi IndentGuidesEven ctermbg=7
                else
                    let g:vim_search_pulse_color_list = [237, 238, 239, 240, 241]
                    call search_pulse#initialize()
                    hi IndentGuidesOdd ctermbg=black
                    hi IndentGuidesEven ctermbg=black
                endif
            elseif g:colors_name == 'zenburn' || g:colors_name == 'badwolf'
                let g:indent_guides_auto_colors = 0
                hi IndentGuidesOdd ctermbg=235
                hi IndentGuidesEven ctermbg=236
            elseif g:colors_name == 'iceberg' || g:colors_name == 'hybrid' || g:colors_name == 'jellybeans'
                let g:indent_guides_auto_colors = 0
                hi IndentGuidesOdd ctermbg=236
                hi IndentGuidesEven ctermbg=237
            elseif g:colors_name == 'hickop'
                let g:indent_guides_auto_colors = 0
                hi IndentGuidesOdd ctermbg=black
                hi IndentGuidesEven ctermbg=237
            else
                let g:indent_guides_auto_colors = 1
            endif
        endif
    endfunction

    " call this function when the right stuff happens
    augroup indent_guides_augroup
        " autocmd!
        autocmd VimEnter,Colorscheme * call SetIndentGuideColors()
    augroup END
    " }}}

    " {{{ vim-instant-markdown
    " turns off auto preview and enables the :InstantMarkdownPreview command
    let g:instant_markdown_autostart = 0
    " }}}

    " {{{ vim-jira-complete
    let g:jiracomplete_url = 'http://10.17.37.213/'
    let g:jiracomplete_username = 'mfunk'
    " }}}

    " {{{ vim-jira-open
    " default is <leader>jo
    let g:jira_browse_url = 'http://10.17.37.213/browse/'
    " }}}

    " vim-json {{{
    " turn off stupid no quotes in JSON except for current line
    set conceallevel=0
    " }}}

    " vim-merginal {{{
    " open the branch list
    nnoremap ,bl :MerginalToggle<cr>
    " }}}

    " {{{ vim-pasta
    let g:pasta_disabled_filetypes = ['nerdtree', 'tagbar']
    " }}}

    " vim-php-cs-fixer {{{
    " don't align phpdoc params, this could cause merge conflicts
    let g:php_cs_fixer_fixers_list = '-phpdoc_params'
    " }}}

    " {{{ vim-php-namespace
    " php add use statement for current class
    inoremap <Leader><Leader>u <C-O>:call PhpInsertUse()<CR>
    noremap <Leader><Leader>u :call PhpInsertUse()<CR>
    " }}}"

    " {{{ vim-php-refactoring
    let g:php_refactor_command='~/.composer/vendor/bin/refactor'
    " }}}

    " vim-phpqa {{{
    " Don't use phpqa for php linting. let syntastic do that.
    let g:phpqa_php_cmd = ''

    " Don't run messdetector on save (default = 1)
    let g:phpqa_messdetector_autorun = 0

    " Don't run codesniffer on save (default = 1)
    let g:phpqa_codesniffer_autorun = 0

    " Show code coverage on load (default = 0)
    " :Phpcc - show code coverage (will ask for a clover XML file if not set)
    " <Leader>qc  " Show/hide code coverage markers
    " let g:phpqa_codecoverage_autorun = 1

    " Clover code coverage XML file
    let g:phpqa_codecoverage_file = "build/logs/clover.xml"
    " }}}

    " vim-rhubarb {{{
    let g:RHUBARB_TOKEN = '4b02d1a1f1cec89163f658c5c748881aed23ac72'
    " }}}

    " {{{ vim-signify
    " I only want signify to worry about git
    let g:signify_vcs_list = [ 'git' ]
    let g:signify_sign_add               = '+'
    let g:signify_sign_change            = '!'
    let g:signify_sign_delete            = '_'
    let g:signify_sign_delete_first_line = '‾'
    " }}}

    " {{{ vim-signature
    " avoid a conflict with NERDTree menu mapping
    let g:SignatureMap = {
      \ 'Leader' : "m",
      \ }
    " let g:SignatureMarkTextHL = 'ErrorMsg'
    " }}}

    " vim-speeddating {{{
    " use <c-b> instead
    let g:speeddating_no_mappings = 1
    nmap  <C-B>     <Plug>SpeedDatingUp
    nmap  <C-X>     <Plug>SpeedDatingDown
    xmap  <C-B>     <Plug>SpeedDatingUp
    xmap  <C-X>     <Plug>SpeedDatingDown
    nmap d<C-B>     <Plug>SpeedDatingNowUTC
    nmap d<C-X>     <Plug>SpeedDatingNowLocal
    " }}}

    " {{{ vim-rooter
    nnoremap <silent> <Leader>pr <Plug>RooterChangeToRootDirectory
    " }}}

    " {{{ vim-startify
    let g:startify_session_dir = '~/.vim/sessions'
    let g:startify_bookmarks = [ '~/.vimrc.local' ]
    " let g:startify_change_to_vcs_root = 1

    " make session autoload work in vim-startify
    " let NERDTreeHijackNetrw = 0

    " disable common but unimportant files
    let g:startify_skiplist = [
        \ 'COMMIT_EDITMSG',
        \ '\.DS_Store'
        \ ]
    " }}}"

    " {{{ vim-tags
    " doesn't want to auto-generate for some reason
    " augroup PhpVimTag
        " " autocmd!
        " autocmd BufWritePost *.php :TagsGenerate
    " augroup END
    " let g:vim_tags_project_tags_command='ctags -R --exclude=.git --exclude=*.log --exclude=*.js --fields=+aimS --languages=php --PHP-kinds=+cf --recurse=yes --tag-relative=yes {OPTIONS} {DIRECTORY} 2>/dev/null'
    " let g:vim_tags_use_vim_dispatch=1
    " }}}

    " {{{ vim-togglelist
    nnoremap <script> <silent> <leader>ll :call ToggleLocationList()<CR>
    nnoremap <script> <silent> <leader>qq :call ToggleQuickfixList()<CR>
    " }}}

    " {{{ vim-autoclose
    " don't put closing "s in vimscript files
    let g:autoclose_vim_commentmode = 1
    " }}}

    " {{{ vimux
    let g:VimuxHeight = "40"
    nnoremap <leader>vp :VimuxPromptCommand<cr>
    nnoremap <leader>vc :VimuxPromptCommand<cr>cd $PWD<cr>:VimuxInspectRunner<cr>
    nnoremap <leader>vl :VimuxRunLastCommand<cr>
    nnoremap <leader>vv :VimuxRunLastCommand<cr>
    nnoremap <leader>vr :VimuxRunLastCommand<cr>
    nnoremap <leader>vi :VimuxInspectRunner<cr>
    nnoremap <leader>vx :VimuxCloseRunner<cr>
    nnoremap <leader>vz :VimuxZoomRunner<cr>
    " }}}

    " {{{ vimux-phpunit
    nnoremap <leader>pf :VimuxPHPUnitRunCurrentFile<cr>
    nnoremap <leader>pu :call VimuxRunCommand("phpunitnotify")<cr>
    nnoremap <leader>pl :VimuxRunLastCommand<cr>
    " }}}

    " {{{ youcompleteme
    " supposed to speed up ycm
    let g:ycm_register_as_syntastic_checker = 0
    " open preview window while completing
    " let g:ycm_add_preview_to_completeopt=1
    " disable youcompleteme
    " let g:ycm_auto_trigger=0
    " let g:ycm_allow_changing_updatetime=0
    let g:ycm_seed_identifiers_with_syntax = 1
    " doesn't work but up arrow does
    " let g:ycm_key_list_previous_completion=['<S-Tab>']
    " }}}

    " {{{ ZoomWin
    " mapping just like <c-a>z for tmux
    nnoremap <c-w>z :ZoomWin<cr>
    " }}}

" }}}

" }}}
