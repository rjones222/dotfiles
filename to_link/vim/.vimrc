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
        set nocompatible        " Must be first line
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
    if filereadable(expand("~/.vimrc.plugins"))
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
    augroup END

    autocmd resCur BufWinEnter * call ResCur()

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
    " set foldenable                  " Auto fold code
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
    " set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Automatically remove trailing whitespaces and ^M chars
    " autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,html.twig,xml,yml,perl autocmd BufWritePre <buffer> call StripTrailingWhitespace()
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
    let g:mapleader = ','
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
        if isdirectory(expand("~/.vim/plugged/nerdtree"))
            let g:NERDShutUp=1
        endif
        if isdirectory(expand("~/.vim/plugged/matchit.zip"))
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

    " NerdTree {{{
        if isdirectory(expand("~/.vim/plugged/nerdtree"))
            " map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <Leader>e :NERDTreeFind<CR>
            nmap <Leader>nt :NERDTreeFind<CR>

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

    " Tabular {{{
        if isdirectory(expand("~/.vim/plugged/tabular"))
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
        if isdirectory(expand("~/.vim/plugged/sessionman.vim/"))
            nnoremap <Leader>sl :SessionList<CR>
            nnoremap <Leader>ss :SessionSave<CR>
            nnoremap <Leader>sc :SessionClose<CR>
        endif
    " }}}

    " JSON {{{
        nmap <Leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0

        " make syntastic check json properly
        au BufRead,BufNewFile *.json set filetype=json
        let g:syntastic_json_checkers=['jsonlint']
    " }}}

    " PyMode {{{
        " Disable if python support not present
        if !has('python')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/plugged/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }}}

    " ctrlp {{{
        if isdirectory(expand("~/.vim/plugged/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            " nnoremap <silent> <D-t> :CtrlP<CR>
            " nnoremap <silent> <D-r> :CtrlPMRU<CR>
            " let g:ctrlp_custom_ignore = {
                " \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                " \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            " On Windows use 'dir' as fallback command.
            " if WINDOWS()
                " let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            " elseif executable('ag')
                " let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            " elseif executable('ack-grep')
                " let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            " elseif executable('ack')
                " let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " else
                " let s:ctrlp_fallback = 'find %s -type f'
            " endif
            " let g:ctrlp_user_command = {
                " \ 'types': {
                    " \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    " \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                " \ },
                " \ 'fallback': s:ctrlp_fallback
            " \ }

            if isdirectory(expand("~/.vim/plugged/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}}}

    " TagBar {{{
        if isdirectory(expand("~/.vim/plugged/tagbar/"))
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
        if isdirectory(expand("~/.vim/plugged/vim-fugitive/"))
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
    if isdirectory(expand("~/.vim/plugged/YouCompleteMe/"))
        let g:acp_enableAtStartup = 0

        " enable completion from tags
        let g:ycm_collect_identifiers_from_tags_files = 1

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

        " For snippet_complete marker.
        " I had to turn this off because it broke vim-json
        " if has('conceal')
            " set conceallevel=2 concealcursor=i
        " endif

        " Disable the neosnippet preview candidate window
        " When enabled, there can be too much visual noise
        " especially when splits are used.
        set completeopt-=preview
    endif
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
        if isdirectory(expand("~/.vim/plugged/undotree/"))
            nnoremap <Leader>uu :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }}}

    " indent_guides {{{
        if isdirectory(expand("~/.vim/plugged/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }}}

    " Wildfire {{{
    if isdirectory(expand("~/.vim/plugged/wildfire.vim/"))
        let g:wildfire_objects = ['iw', 'iW', 'i"', "i'", "i]", "i}", "il", "ip", "ie"]
    endif
    " }}}

    " vim-airline {{{
    if isdirectory(expand("~/.vim/plugged/vim-airline/"))

        " whether to user powerline fonts in vim-airline
        " let g:airline_powerline_fonts=1

        " which airline theme to use
        " if you turn this off it should follow the current theme
        " let g:airline_theme='solarized'

        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        " if isdirectory(expand("~/.vim/plugged/vim-airline/"))
            " if !exists('g:airline_theme')
                " let g:airline_theme = 'solarized'
            " endif
            " if !exists('g:airline_powerline_fonts')
                " " Use the default set of separators with a few customizations
                " let g:airline_left_sep='›'  " Slightly fancier than '>'
                " let g:airline_right_sep='‹' " Slightly fancier than '<'
            " endif
        " endif
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
            " in case t_Co alone doesn't work, add this as well:
            let &t_AB="\e[48;5;%dm"
            let &t_AF="\e[38;5;%dm"
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
    " allow setting .exrc in root project folders
    set exrc
    set secure

    let g:snips_author = 'Michael Funk <mike.funk@demandmedia.com>'

    " this allows you to run :checktime to update all open buffers
    set autoread
    autocmd CursorHold * checktime

    " Send the selected hunk to hastebin using the haste ruby gem
    vmap <Leader>hb <esc>:'<,'>:w ! haste<CR>

    augroup php_select_around_function
        autocmd!
    augroup END

    " select around a function in php
    autocmd php_select_around_function FileType php nnoremap vaf ?func.*\n*\s*{<cr>ma/{<cr>%mb`av`b
    autocmd php_select_around_function FileType php vmap af o<esc>kvaf

    " Use a blinking upright bar cursor in Insert mode, a blinking block in normal
    " @link http://www.reddit.com/r/vim/comments/2of45a/terminal_vim_changing_cursor_shape_on_linux/cmmu01h
    " disabled because it gets buggy with tmux.
    " if &term == 'xterm-256color' || &term == 'screen-256color'
        " let &t_SI = '\<Esc>[5 q'
        " let &t_EI = '\<Esc>[1 q'
    " endif

    " if exists('$TMUX')
        " let &t_EI = '\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\'
        " let &t_SI = '\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\'
    " endif

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
    if executable('phpunit')
        if executable('tmux')
            command! VimuxPHPUnitRunCurrentFile :call s:VimuxPHPUnitRunCurrentFile()

            function! s:VimuxPHPUnitRunCurrentFile()
                call VimuxRunCommand('phpunit ' . expand('%:p'))
            endfunction
        endif
    endif

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
    if executable('ag')
        set grepprg=ag\ --nocolor\ --nogroup\ --silent.
    endif
    " set grepprg=grep -nH

    " since , replaces leader, use \ to go back in a [f]ind
    noremap \ ,

    " get rid of annoying 'User defined completion (^U^N^P) Pattern not found'
    " https://github.com/JazzCore/neocomplcache-ultisnips/issues/1#issuecomment-62128128
    " set shortmess+=c

    " css tags with tagbar
    " only works with a specific fork of ctags... but i'm already on a fork
    " of ctags

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
    " nnoremap <leader>fj :%!python -m json.tool<cr>
    if executable('json')
        nnoremap <leader>fj :%!json<cr>
    endif
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
    augroup quickfix_augroup
        autocmd!
    augroup END

    " set quickfix window height min and max  automatically
    autocmd quickfix_augroup FileType qf call AdjustWindowHeight(3, 5)

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

    " augroup phpman_autogroup
        " autocmd!
    " augroup END

    " use php documentation with <shift>K from pear package pman"
    " disabled for now - trying alvan/vim-php-manual instead
    " if executable('pman')
        " autocmd phpman_autogroup FileType php set keywordprg=pman
        " autocmd FileType php set keywordprg=/Users/mfunk/.composer/vendor/bin/pman\ -P\ less
        " autocmd FileType php nnoremap K :Silent pman <cword> <CR>
        " autocmd FileType php nnoremap K :Silent /usr/local/php5/bin/pman <cword> <CR>
        " autocmd FileType php nnoremap K <Plug>(phpcomplete-extended-doc)
    " endif

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
        autocmd!
    augroup END

    " autocmd highlight_augroup CursorMoved * exe printf('match Underlined /\V\<%s\>/', escape(expand('<cword>'), '/\'))

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

    " Abbreviations {{{
    if executable('phpunit')
        abbrev pft PHPUnit_Framework_TestCase
    endif
    if executable('php')
        abbrev gm !php artisan generate:model
        abbrev gc !php artisan generate:controller
        abbrev gmig !php artisan generate:migration
    endif
    " }}}

    augroup qfclose_augroup
        autocmd!
    augroup END

    " if the last window is a quickfix, close it
    autocmd qfclose_augroup WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif

    augroup highlight_augroup
        autocmd!
    augroup END

    " 2 space indent in front-end
    autocmd highlight_augroup FileType smarty,blade,html,javascript,json,css,html.twig,coffee,yaml :call Tab2()

    " sets everything to 2 spaces. For some reason just calling all this in
    " one line does not set shiftwidth, but sets the others fine.
    function! Tab2()
        setlocal shiftwidth=2
        setlocal tabstop=2
        setlocal softtabstop=2
        setlocal expandtab
        :%retab!
    endfunction

    " change indentation size with :Indent
    command! Indent :call Indent()
    function! Indent()
        let s:size_of_indentation = input("New indentation (".&ts.",".&sts.",".&sw.") => ")
        if(s:size_of_indentation != '')
            execute "setlocal ts=".s:size_of_indentation.""
            execute "setlocal sts=".s:size_of_indentation.""
            execute "setlocal sw=".s:size_of_indentation.""
        endif
    endfunction

    " convert quickly between tabs and spaces with :TabToSpace and :SpaceToTab
    command! TabToSpace :setlocal expandtab | %retab!
    command! SpaceToTab :setlocal noexpandtab | %retab!
" }}}

" Key Mapping {{{
    " soft wrapping
    command! -nargs=* Wrap set wrap linebreak nolist

    " Ranger browser in the current dir
    " @link http://www.reddit.com/r/vim/comments/2va2og/ranger_the_cli_file_manager_xpost_from/
    function! RangerChooser()
        let temp = tempname()
        exec 'silent !ranger --choosefiles=' . shellescape(temp)
        if !filereadable(temp)
            redraw!
            " Nothing to read.
            return
        endif
        let names = readfile(temp)
        if empty(names)
            redraw!
            " Nothing to open.
            return
        endif
        " Edit the first item.
        exec 'edit ' . fnameescape(names[0])
        " Add any remaning items to the arg list/buffer list.
        for name in names[1:]
            exec 'argadd ' . fnameescape(name)
        endfor
        redraw!
    endfunction

    nnoremap <leader>rc :call RangerChooser()<CR>

    " open vhosts file
    command! Vhost tabe /etc/apache2/extra/httpd-vhosts.conf

    " word wrap the current paragraph
    nnoremap Q gqap

    " close preview window with ,pp because I remap <c-w>z to zoom the window.
    " works like ,qq and ,ll except it can't re-open it of course
    nnoremap <leader>pp :pclose<cr>

    " paragraph nav I can remember - like unimpaired
    nnoremap [{ {j
    nnoremap ]} }k

    " sort use statements and come back
    command! SortUse execute "normal! msgg/use\ <cr>vip:sort<cr>\`s:delmarks s<cr>:nohlsearch<cr>"
    nnoremap <leader>su :SortUse<cr>

    if isdirectory(expand("~/.vim/plugged/vim-dispatch"))
        " dotfile updates and private stuff updates
        command! Dotupdates :Dispatch cd $HOME/.dotfiles && git add -A && git commit -am 'updates' && git push &&cd -
        command! Privateupdates :Dispatch cd $HOME/.private-stuff && git add -A && git commit -am 'updates' && git push &&cd -
        nnoremap <leader>tu :Dotupdates<cr>
        nnoremap <leader>tv :Privateupdates<cr>
    endif

    if isdirectory(expand("~/.vim/plugged/vim-dispatch"))
        " working commit
        command! Working :Dispatch cd $(git rev-parse --show-toplevel) && git add --all .; git commit -am "rebase me!!" && cd -
    endif

    " source vimrc
    command! Source :so $MYVIMRC

    " remove trailing spaces
    " command! StripTrailingWhitespace :%s/\s\+$//

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
    " nnoremap <leader>bi :so $MYVIMRC<cr> :BundleInstall<cr>
    " nnoremap <leader>bc :so $MYVIMRC<cr> :BundleClean!<cr>
    " nnoremap <leader>bu :so $MYVIMRC<cr> :BundleUpdate<cr>

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

    nnoremap <leader>bo :BufOnly<cr>

    " open existing buffer in a newtab
    " nnoremap <leader>te :ls<cr>:tabedit #

    " open link under cursor in browser
    nnoremap <leader>ou yiW:!open <c-r>" &<cr><cr>

    " {{{ put cursor at end of text on y and p
    vnoremap <silent> y y`]
    vnoremap <silent> p p`]
    nnoremap <silent> p p`]
    " }}}

" }}}

" Theme {{{

    augroup cosco_vim_augroup
        autocmd!
    augroup END

    " hello... this is an apache config file
    autocmd cosco_vim_augroup FileType conf set ft=apache

    set guifont=Meslo\ LG\ M\ Regular\ for\ Powerline:h14
    " supposed to help colorschemes work better in 256 colors
    let g:rehash256 = 1

    " {{{ global powerline fonts switch is defined in .vimrc.before.local
        " this will turn off powerline fonts for tmuxline, vim-powerline,
        " promptline, etc.
        let g:global_powerline_switch = 1
        " let g:global_powerline_switch = 0

        if g:global_powerline_switch == 1
            let g:airline_powerline_fonts=1
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
            let g:airline_powerline_fonts=0
            let g:promptline_powerline_symbols = 0
            let g:tmuxline_powerline_separators = 0
            let g:airline_left_sep = ''
            let g:airline_left_alt_sep = ''
            let g:airline_right_sep = ''
            let g:airline_right_alt_sep = ''
        endif
    " }}}

    " {{{ colorscheme
    if !exists('g:colorscheme_set')
        silent! colorscheme lucius
        set background=dark
        " let g:lucius_no_term_bg=1
        " colorscheme solarized
        " colorscheme badwolf
        let g:colorscheme_set=1
    endif
    " set background=light
    if isdirectory(expand("~/.vim/plugged/vim-colors-solarized"))
        " let g:solarized_contrast="normal"
        " solarized stuff I use
        let g:solarized_termtrans=0
        let g:solarized_termcolors=16
        let g:solarized_diffmode="high"
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
    endif
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
    if isdirectory(expand("~/.vim/plugged/vim-easymotion")) && isdirectory(expand("~/.vim/plugged/vim-colors-solarized"))
        hi link EasyMotionTarget ErrorMsg
        hi link EasyMotionShade  Comment
    endif
    " }}}

    " {{{ vim-gitgutter better background
    " highlight clear SignColumn
    " hi link SignColumn LineNr
    " }}}

    " {{{ syntax highlighting for Vagrantfile
    augroup vagrant
        autocmd!
    augroup END

    autocmd vagrant BufRead,BufNewFile Vagrantfile set filetype=ruby
    " }}}

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

    " {{{ Colorizer
    if isdirectory(expand("~/.vim/plugged/Colorizer"))
        let g:colorizer_auto_filetype='css,scss,less,sass'
    endif
    " }}}

    " cosco.vim {{{
    if isdirectory(expand("~/.vim/plugged/cosco.vim"))
        augroup cosco_vim_augroup
            autocmd!
        augroup END

        autocmd cosco_vim_augroup FileType javascript,css,php nnoremap <silent> <leader>; :call cosco#commaOrSemiColon()<CR>
        autocmd cosco_vim_augroup FileType javascript,css,php inoremap <silent> <leader>; <ESC>:call cosco#commaOrSemiColon()"<CR>a
    endif
    " }}}

    " {{{ ctrlp
    if isdirectory(expand("~/.vim/plugged/ctrlp.vim"))
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
    endif
    " }}}

    " ctrlp-smarttabs {{{
    if isdirectory(expand("~/.vim/plugged/ctrlp-smarttabs"))
        let g:ctrlp_extensions = g:ctrlp_extensions + ['smarttabs']
        nnoremap <leader><space> :CtrlPSmartTabs<cr>
    endif
    " }}}

    " {{{ dispatch
    if isdirectory(expand("~/.vim/plugged/vim-dispatch"))
        nnoremap <silent> <Leader>di :call CallDispatchWithCommand() <CR>

        function! CallDispatchWithCommand()
          let dispatch_command = input('> ')
          execute ':Dispatch ' . dispatch_command
        endfunction
    endif
    " }}}

    " {{{ easytags
    " this version is for ctags-better-php
    nnoremap <silent> <Leader>ut :silent Dispatch! echo 'exporting ctags...' && cd $(git rev-parse --show-toplevel) && ctags -R --exclude=.git --exclude='*.log' --fields=+aimS --languages=php --PHP-kinds=+cf --sort=foldcase<CR>

    " this version is for standard ctags-exuberant
    " nnoremap <silent> <Leader>ut :silent Dispatch! echo 'exporting ctags...' && cd $(git rev-parse --show-toplevel) && ctags -R --PHP-kinds=+cf<CR>

    if isdirectory(expand("~/.vim/plugged/vim-easytags"))
        " easytags just doesn't work well. it blocks the ui when updating (doesn't
        " use dispatch), it doesn't use my custom easy_tags_cmd, and the
        " highlighting won't use my custom highlight. Fuck it, we'll do it live!

        " augroup phpctags
            " autocmd BufWritePost *.php UpdateCtags
        " augroup END

        " Easytags blocks the UI on pause, which sucks! It also apparently
        " slows down the UI with it's highlighting, which I can't seem to switch
        " to underlining anyway. What is a better solution? In the mean time I
        " map to update manually with ,ct.
        " let g:easytags_auto_update = 0
        " let g:easytags_dynamic_files=1
        " let g:easytags_updatetime_warn=0
        " let g:easytags_python_enabled=1
        " let b:easytags_auto_highlight=0

        " this doesn't seem to work, it just disables highlighting. I can't figure
        " out why.
        " highlight phpFunctionsTag cterm=underline gui=underline term=underline
        " highlight phpClassesTag cterm=underline gui=underline term=underline

        " asynchronous tag gen
        let g:easytags_async = 1
        let g:easytags_opts = ['-R', '--exclude=.git', '--exclude="*.log"', '--fields=+aimS', '--languages=php', '--PHP-kinds=+cf' , '--sort=foldcase']
    endif
    " }}}

    " {{{ fugitive
    if isdirectory(expand("~/.vim/plugged/vim-fugitive"))
        " let g:fugitive_github_domains = ['https://gitlab.git.internetbrands.com', 'https://git.github.com']
        let g:fugitive_github_domains = ['http://gitlab.prod.dm.local', 'https://git.github.com']
        " filename
        hi default link User1 Identifier"blue
        " flags
        hi default link User2 Statement"green
        " errors
        hi default link User3 Error"orange
        " fugitive
        hi default link User4 Special

        augroup fugitive_augroup
            autocmd!
        augroup END

        " reset file to HEAD in fugitive commit window
        autocmd fugitive_augroup FileType gitcommit nmap <buffer> U :Git checkout -- <C-r><C-g><CR>
        " open quickfix window on git grep
        autocmd fugitive_augroup QuickFixCmdPost *grep* cwindow

        " Fugitive Commands
        command! -bar -nargs=* Gpull execute 'Git pull' <q-args> 'origin' fugitive#head()
        command! -bar -nargs=* Gpush execute 'Git push' <q-args> 'origin' fugitive#head()
        command! -bar -nargs=* Gpurr execute 'Git pull --rebase' <q-args> 'origin' fugitive#head()
        command! Gpnp silent Gpull | Gpush
        command! Gprp silent Gpurr | Gpush
        command! Gsync :Dispatch git checkout develop && git pull && git checkout - && git merge develop
        command! Gnuke silent execute 'Git reset --hard'

        silent! unmap <leader>gp
        " nnoremap <silent> <leader>gpu :Gpush<CR>
        " nnoremap <silent> <leader>gpl :Gpull<CR>:e<CR>
        nnoremap <Leader>g- :Silent Git stash<CR>:e<CR>
        nnoremap <Leader>g+ :Silent Git stash pop<CR>:e<CR>
        nnoremap <leader>gn :Gnuke<cr>
        nnoremap <leader>gps :Dispatch! git push<CR>
        nnoremap <leader>gpu :Dispatch! git push<CR>
        nnoremap <leader>gpl :Dispatch! git pull<CR>:e<cr>
        " nnoremap <leader>ga :Git add %:p<CR><CR>
        nnoremap <leader>ga :Git add -A<CR><CR>
    endif
    " }}}"

    " {{{ gitv
    if isdirectory(expand("~/.vim/plugged/gitv.vim"))
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
    endif
    " }}}

    " matchit {{{
    if isdirectory(expand("~/.vim/plugged/matchit.vim"))
        augroup blade_html_features
            autocmd!
        augroup END

        " get the best of all worlds
        au blade_html_features FileType blade set ft=html | set syntax=blade | let b:match_debug=1
    endif
    " }}}

    " NERDTree {{{
    if isdirectory(expand("~/.vim/plugged/nerdtree"))
        let NERDTreeIgnore=['\.DS_Store$', '\.vim$']
        " extra space in NERDCommenter comments
        let g:NERDSpaceDelims="1"

        augroup NERDTreeCustomizations
            autocmd!
        augroup END

        " If I don't do this then signature overwrites my nerdtree menu map
        autocmd NERDTreeCustomizations FileType nerdtree nnoremap <buffer> <nowait> m :call nerdtree#ui_glue#invokeKeyMap("m")<CR>

        " NERDTree expand dirs with one child
        " let NERDTreeCasadeOpenSingleChildDir=1

        " NERDTree change keyboard shortcuts to use vim-nerdtree-tabs
        " map <C-e> :NERDTreeTabsToggle<CR>:NERDTreeMirrorOpen<CR>
        " map <C-e> :NERDTreeTabs<CR>:NERDTreeMirrorOpen<CR>
        " map <C-e> :NERDTreeTabsToggle<CR>
        map <C-e> :NERDTreeMirrorToggle<CR>

        augroup startify_augroup
            autocmd!
        augroup END

        " don't open a split for ctrlp or nerdtree
        autocmd startify_augroup FileType startify setlocal buftype=
    endif
    " }}}

    " {{{ neocomplete
    if isdirectory(expand("~/.vim/plugged/neocomplete.vim")) && has('lua')
        " Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
        " Disable AutoComplPop.
        let g:acp_enableAtStartup = 0
        " Use neocomplete.
        let g:neocomplete#enable_at_startup = 1
        " Use smartcase.
        let g:neocomplete#enable_smart_case = 1
        " Set minimum syntax keyword length.
        let g:neocomplete#sources#syntax#min_keyword_length = 3
        let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

        " Define dictionary.
        let g:neocomplete#sources#dictionary#dictionaries = {
            \ 'default' : '',
            \ 'vimshell' : $HOME.'/.vimshell_hist',
            \ 'scheme' : $HOME.'/.gosh_completions'
                \ }

        " Define keyword.
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'

        " Plugin key-mappings.
        inoremap <expr><C-g>     neocomplete#undo_completion()
        inoremap <expr><C-l>     neocomplete#complete_common_string()

        " Recommended key-mappings.
        " <CR>: close popup and save indent.
        inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
          return neocomplete#close_popup() . "\<CR>"
          " For no inserting <CR> key.
          "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
        endfunction
        " <TAB>: completion.
        inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
        " <C-h>, <BS>: close popup and delete backword char.
        inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
        inoremap <expr><C-y>  neocomplete#close_popup()
        inoremap <expr><C-e>  neocomplete#cancel_popup()
        " Close popup by <Space>.
        "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

        " For cursor moving in insert mode(Not recommended)
        "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
        "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
        "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
        "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
        " Or set this.
        "let g:neocomplete#enable_cursor_hold_i = 1
        " Or set this.
        "let g:neocomplete#enable_insert_char_pre = 1

        " AutoComplPop like behavior.
        "let g:neocomplete#enable_auto_select = 1

        " Shell like behavior(not recommended).
        "set completeopt+=longest
        "let g:neocomplete#enable_auto_select = 1
        "let g:neocomplete#disable_auto_complete = 1
        "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

        " Enable omni completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

        " Enable heavy omni completion.
        if !exists('g:neocomplete#sources#omni#input_patterns')
          let g:neocomplete#sources#omni#input_patterns = {}
        endif
        "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

        " For perlomni.vim setting.
        " https://github.com/c9s/perlomni.vim
        let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        " }}}

        " {{{ openbrowser.vim
        if isdirectory(expand("~/.vim/plugged/openbrowser.vim"))
            " Open URI under cursor.
            nmap <leader>gu <Plug>(openbrowser-open)

            " Open selected URI.
            vmap <leader>gu <Plug>(openbrowser-open)
        endif
    " if neocomplete is a directory
    endif
    " }}}

    " {{{ PDV
    " (php documentor for vim)
    if isdirectory(expand("~/.vim/plugged/pdv"))
        let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
        nnoremap <buffer> <leader>pd :call pdv#DocumentWithSnip()<CR>
    endif
    " }}}

    " {{{ phpcomplete
    if isdirectory(expand("~/.vim/plugged/phpcomplete.vim"))
        " phpcomplete omni complete for neocomplcache
        augroup phpcomplete_augroup
            autocmd!
        augroup END

        " autocmd BufNewFile,BufRead *.twig,*.blade.php,*.tpl set filetype=html
        " autocmd BufNewFile,BufRead *.twig,*.blade.php,*.tpl,*.css,*.js,*.html set ts=2 sw=2 sts=2
        " autocmd FileType php set omnifunc=phpcomplete_extended#CompletePHP
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
        silent! nunmap <buffer> <unique> <C-]>
        silent! nunmap <buffer> <unique> <C-W><C-]>
        nnoremap <silent> <C-]> :<C-u>call phpcomplete#JumpToDefinition('normal')<CR>
        nnoremap <silent> <C-W><C-]> :<C-u>call phpcomplete#JumpToDefinition('split')<CR>
    endif
    " }}}"

    " {{{ phpctags
    if isdirectory(expand("~/.vim/plugged/tagbar-phpctags.vim"))
        " phpctags
        let g:tagbar_phpctags_memory_limit = '512M'
    endif
    " }}}"

    " {{{ php-documentor-vim
    if isdirectory(expand("~/.vim/plugged/php-doc-modded")) || isdirectory(expand("~/.vim/plugged/php-documentor-vim"))
        " PDV comment parameters
        let g:pdv_cfg_Package   = "Example"
        let g:pdv_cfg_Author    = "Michael Funk <mike.funk@demandmedia.com>"
        let g:pdv_cfg_Copyright = "Copyright 2015 Demand Media, Inc. All Rights Reserved."
        let g:pdv_cfg_License   = ""
        let g:pdv_cfg_Version   = ""
        let g:pdv_cfg_ClassTags = ["author"]

        " skip those stupid closing comments for functions and classes
        let g:pdv_cfg_autoEndFunction = 0
        let g:pdv_cfg_autoEndClass = 0

        let g:pdv_cfg_php4always = 0

        augroup phpdoc_augroup
            autocmd!
        augroup END

        au phpdoc_augroup BufRead,BufNewFile *.php inoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
        au phpdoc_augroup BufRead,BufNewFile *.php nnoremap <buffer> <leader>pd :call PhpDocSingle()<CR>
        au phpdoc_augroup BufRead,BufNewFile *.php vnoremap <buffer> <leader>pd :call PhpDocRange()<CR>
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
    endif
    " }}}"

    " sideways.vim {{{
    if isdirectory(expand("~/.vim/plugged/sideways.vim"))
        nnoremap <c-h> :SidewaysLeft<cr>
        nnoremap <c-l> :SidewaysRight<cr>
    endif
    " }}}

    " sunset {{{
    if isdirectory(expand("~/.vim/plugged/sunset"))
        let g:sunset_utc_offset = -8
        let g:sunset_latitude = 33.930324
        let g:sunset_longitude = -118.395538
    endif
    " }}}

    " switch.vim {{{
    if isdirectory(expand("~/.vim/plugged/sunset"))
        let g:switch_definitions =
            \ [
            \    ['true', 'false'],
            \ ]
    endif
    " }}}

    " Syntastic {{{
    if isdirectory(expand("~/.vim/plugged/syntastic"))
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

        " use npm package to check react scripts
        " @link https://github.com/jaxbot/syntastic-react
        let g:syntastic_javascript_checkers = ['jsxhint']
        let g:syntastic_javascript_jsxhint_exec = 'jsx-jshint-wrapper'
        " let g:syntastic_js_checkers = []

        " spiffy error columns
        let g:syntastic_error_symbol='✗'
        let g:syntastic_warning_symbol='⚠'
        let g:syntastic_style_error_symbol='✗'
        let g:syntastic_style_warning_symbol='⚠'
    endif
    " }}}

    " {{{ tabular
    if isdirectory(expand("~/.vim/plugged/tabular"))
        nmap <leader>a> :Tabularize /=><cr>
        vmap <leader>a> :Tabularize /=><cr>
    endif
    " }}}"

    " {{{ tagbar
    if isdirectory(expand("~/.vim/plugged/tagbar"))
        " tagbar autofocus is the whole point of tagbar
        let g:tagbar_autofocus = 1
        let g:tagbar_autoclose = 1
        " let g:tagbar_autopreview = 1

        let g:tagbar_type_css = {
            \ 'ctagstype' : 'Css',
            \ 'kinds'     : [
                \ 'c:classes',
                \ 's:selectors',
                \ 'i:identities'
            \ ]
        \ }

        " markdown ctags with tagbar?! awesome!
        let g:tagbar_type_markdown = {
            \ 'ctagstype' : 'markdown',
            \ 'kinds' : [
                \ 'h:Heading_L1',
                \ 'i:Heading_L2',
                \ 'k:Heading_L3'
            \ ]
        \ }

        " puppet tagbar
        let g:tagbar_type_puppet = {
            \ 'ctagstype': 'puppet',
            \ 'kinds': [
                \'c:class',
                \'s:site',
                \'n:node',
                \'d:definition'
            \]
        \}

        " ultisnips tagbar - ok this is getting crazy
        let g:tagbar_type_snippets = {
            \ 'ctagstype' : 'snippets',
            \ 'kinds' : [
                \ 's:snippets',
            \ ]
        \ }
    endif
    " }}}"

    " tagexplorer.vim {{{

    if isdirectory(expand("~/.vim/plugged/tagexplorer.vim"))
        nnoremap <leader>te :TagExplorer<cr>
    endif
    " }}}

    " TagHighlight {{{
    " this plugin takes way too much configuration to work.
    if executable('python') && isdirectory(expand("~/.vim/plugged/TagHighlight"))
        hi Class guifg=Purple cterm=underline
        hi DefinedName guifg=Purple cterm=underline
        hi Enumerator guifg=Purple cterm=underline
        hi Function guifg=Purple cterm=underline
        hi EnumerationName guifg=Purple cterm=underline
        hi Member guifg=Purple cterm=underline
        hi Structure guifg=Purple cterm=underline
        hi Type guifg=Purple cterm=underline
        hi Union guifg=Purple cterm=underline
        hi GlobalConstant guifg=Purple cterm=underline
        hi GlobalVariable guifg=Purple cterm=underline
        hi LocalVariable guifg=Purple cterm=underline
    endif
    " }}}

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

    " {{{ ultisnips
    if isdirectory(expand("~/.vim/plugged/ultisnips"))
        " ultisnips start with my ultisnips
        " let g:UltiSnipsSnippetDirectories=['UltiSnips', 'ultisnips_snippets']

        " enable vim-snippets in ultisnips
        " set runtimepath+=~/.vim/plugged/vim-snippets
        let g:UltiSnipsDontReverseSearchPath="1"
        let g:UltiSnipsEditSplit="vertical"
        let g:UltiSnipsListSnippets='<c-l>'
        " let g:UltiSnipsExpandTrigger='<a-;>'
        " let g:UltiSnipsJumpForwardTrigger='<c-l>'
        " let g:UltiSnipsJumpBackwardTrigger='<c-h>'
        " let g:UltiSnips#ExpandSnippetOrJump='<a-;>'

        " remap Ultisnips for compatibility for YCM
        let g:UltiSnipsExpandTrigger = '<C-j>'
        " let g:UltiSnipsExpandTrigger = '<cr>'
        " let g:UltiSnipsExpandTrigger = '<C-l>'
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
    endif
    " }}}

    " {{{ vdebug xdebug plugin
    if isdirectory(expand("~/.vim/plugged/vdebug"))
        let g:vdebug_options = {}
        let g:vdebug_options['continuous_mode'] = 1
        let g:vdebug_options['timeout'] = 30
        " the local server ip
        " let g:vdebug_options['server'] = '192.168.56.1'
        let g:vdebug_options['server'] = '127.0.0.1'
        let g:vdebug_options['port'] = '9000'
        let g:vdebug_options['ide_key'] = 'netbeans-xdebug'
        " can add multiple path maps to this array, just duplicate the line
        " below and add another. remote is first, local is second.
        let g:vdebug_options['path_maps'] = {
        \   '/var/www/sites/acp-hotrodhotline': '/Library/WebServer/Documents/acp-hotrodhotline'
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
    " }}}"

    " {{{ vim-airline
    if isdirectory(expand("~/.vim/plugged/vim-airline"))
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
        augroup php_tagbar
            autocmd!
        augroup END

        " warning this is really slow. So I only enabled it for php files.
        autocmd php_tagbar FileType php let g:airline#extensions#tagbar#enabled = 1
        autocmd php_tagbar FileType coffee let g:airline#extensions#tagbar#enabled = 1

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
        let g:airline#extensions#tabline#enabled = 1
        " let g:airline#extensions#tabline#left_sep = ' '
        " let g:airline#extensions#tabline#left_alt_sep = '|'
        " let g:airline#extensions#tabline#left_alt_sep = ' '
    endif

    " }}}

    " {{{ vim-brightest
    if isdirectory(expand("~/.vim/plugged/vim-brightest"))
        " whitelist for filetypes I often use
        let g:brightest#enable_filetypes = {
        \   "_" : 0,
        \   "php" : 1,
        \   "javascript" : 1,
        \   "coffee" : 1,
        \   "sql" : 1,
        \   "html.twig" : 1,
        \   "blade" : 1
        \}
    endif
    " }}}

    " vim-github-comment {{{
    if isdirectory(expand("~/.vim/plugged/vim-github-comment"))
        let g:github_user = 'mikedfunk'
    endif
    " }}}

    " {{{ vim-indentline
    if isdirectory(expand("~/.vim/plugged/indentLine"))
        " let g:indentLine_leadingSpaceEnabled = 1
        let g:indentLine_char = '┆'
    endif
    " }}}

    " {{{ vim-instant-markdown
    if isdirectory(expand("~/.vim/plugged/vim-instant-markdown"))
        " turns off auto preview and enables the :InstantMarkdownPreview command
        let g:instant_markdown_autostart = 0
    endif
    " }}}

    " {{{ vim-jira-complete
    " this will not work without 'pip install requests'
    if isdirectory(expand("~/.vim/plugged/vim-jira-complete"))
        let g:jiracomplete_url = 'http://10.17.37.213/'
        let g:jiracomplete_username = 'mfunk'
        " imap <silent> <unique> <leader>jc <Plug>JiraComplete
    endif
    " }}}

    " {{{ vim-jira-open
    if isdirectory(expand("~/.vim/plugged/vim-jira-open"))
        " default is <leader>jo
        let g:jira_browse_url = 'http://10.17.37.213/browse/'
    endif
    " }}}

    " vim-json {{{
    if isdirectory(expand("~/.vim/plugged/vim-json"))
        " turn off stupid no quotes in JSON except for current line
        " set conceallevel=0
        let g:vim_json_syntax_conceal = 0
        " uh oh, it doesn't work well with indentLine plugin...
        " https://github.com/elzr/vim-json/issues/23#issuecomment-40293049
        let g:indentLine_noConcealCursor = ""
        " WORK DAMN IT
        " autocmd InsertEnter *.json setlocal conceallevel=2 concealcursor=
        " autocmd InsertLeave *.json setlocal conceallevel=2 concealcursor=inc
        " autocmd BufEnter *.json setlocal conceallevel=2 concealcursor=
    endif
    " }}}

    " vim-lotr {{{
    if isdirectory(expand("~/.vim/plugged/vim-lotr"))
        " show registers in a sidebar
        " nnoremap <leader>sr :LOTRToggle<cr>
        nnoremap <leader>rr :LOTRToggle<cr>
    endif
    " }}}

    " {{{ vim-pasta
    if isdirectory(expand("~/.vim/plugged/vim-pasta"))
        let g:pasta_disabled_filetypes = ['nerdtree', 'tagbar']
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
    "
    " {{{ vim-php-namespace
    if isdirectory(expand("~/.vim/plugged/vim-php-namespace"))
        " php add use statement for current class
        inoremap <Leader><Leader>u <C-O>:call PhpInsertUse()<CR>
        noremap <Leader><Leader>u :call PhpInsertUse()<CR>
    endif
    " }}}"

    " vim-phpqa {{{
    if isdirectory(expand("~/.vim/plugged/vim-phpqa"))
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
    endif
    " }}}

    " vim-plug {{{
    nnoremap <leader>bi :so ~/.vimrc.plugins<cr> :PlugInstall<cr>
    nnoremap <leader>bc :so ~/.vimrc.plugins<cr> :PlugClean!<cr>
    nnoremap <leader>bu :so ~/.vimrc.plugins<cr> :PlugUpdate<cr>

    " how many threads to use at once when updating, installing, etc. default
    " is 16
    " let g:plug_threads=32
    " }}}

    " vim-rails {{{
    if isdirectory(expand("~/.vim/plugged/vim-rails"))
        let g:rubycomplete_buffer_loading = 1
    endif
    " }}}

    " {{{ vim-signify
    if isdirectory(expand("~/.vim/plugged/vim-signify"))
        " I only want signify to worry about git
        let g:signify_vcs_list = [ 'git' ]
        let g:signify_sign_add               = '+'
        let g:signify_sign_change            = '!'
        let g:signify_sign_delete            = '_'
        let g:signify_sign_delete_first_line = '‾'
    endif
    " }}}

    " vim-speeddating {{{
    if isdirectory(expand("~/.vim/plugged/vim-speeddating"))
        " use <c-b> instead
        let g:speeddating_no_mappings = 1
        nmap  <C-B>     <Plug>SpeedDatingUp
        nmap  <C-X>     <Plug>SpeedDatingDown
        xmap  <C-B>     <Plug>SpeedDatingUp
        xmap  <C-X>     <Plug>SpeedDatingDown
        nmap d<C-B>     <Plug>SpeedDatingNowUTC
        nmap d<C-X>     <Plug>SpeedDatingNowLocal
    endif
    " }}}

    " {{{ vim-rooter
    if isdirectory(expand("~/.vim/plugged/vim-rooter"))
        nnoremap <silent> <Leader>pr <Plug>RooterChangeToRootDirectory
    endif
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

        " make session autoload work in vim-startify
        " let NERDTreeHijackNetrw = 0

        " disable common but unimportant files
        let g:startify_skiplist = [
            \ 'COMMIT_EDITMSG',
            \ '\.DS_Store'
            \ ]

        " make vim startify show recent files
        set viminfo='100,n$HOME/.vim/files/info/viminfo
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

    " VimCompletesMe {{{
    if isdirectory(expand("~/.vim/plugged/VimCompletesMe")) && executable('tmux')
        let b:vcm_tab_complete = "omni"
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

        nnoremap <leader>pf :VimuxPHPUnitRunCurrentFile<cr>
        nnoremap <leader>pu :call VimuxRunCommand("phpunit")<cr>
        nnoremap <leader>pp :VimuxRunLastCommand<cr>
    endif
    " }}}

    " {{{ youcompleteme
    if isdirectory(expand("~/.vim/plugged/YouCompleteMe"))
        " supposed to speed up ycm
        let g:ycm_register_as_syntastic_checker = 0
        " open preview window while completing
        let g:ycm_add_preview_to_completeopt=1
        " disable youcompleteme
        " let g:ycm_auto_trigger=0
        " let g:ycm_allow_changing_updatetime=0
        let g:ycm_seed_identifiers_with_syntax = 1
        " doesn't work but up arrow does
        " let g:ycm_key_list_previous_completion=['<S-Tab>']
    endif
    " }}}

    " {{{ ZoomWin
    if isdirectory(expand("~/.vim/plugged/ZoomWin"))
        " mapping just like <c-a>z for tmux
        nnoremap <c-w>z :ZoomWin<cr>
    endif
    " }}}

" }}}

" }}}
