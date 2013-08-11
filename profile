alias wr='cd ~/Sites' # web root
alias selenium='java -jar /usr/local/bin/selenium-server.jar'
alias gitk='gitk 2>/dev/null' # fix terminal output error
alias vimupdate='vim +BundleClean! +qall && vim +BundleInstall! +qall'
alias viminstall='vim +BundleClean! +qall && vim +BundleInstall +qall'
alias watch='observr ~/.dotfiles/observr.conf.rb' # phpunit on dir change
alias lsd="ls -GpFha" # additional details
# I forget I'm not in vim sometimes...
alias :q="exit"
alias :pwd="pwd"
alias :cd="cd"
alias :so="source"
alias mux="tmuxinator"
alias artisan="php artisan"
alias migrate="php artisan migrate:refresh --seed"
alias vim="mvim -v" # use macvim executable in terminal mode
alias e2='cd ~/Sites/einstein2'
eval "$(hub alias -s)" # alias hub to git
alias g="git"
alias coverage="phpunit --debug && open build/coverage/index.html"
alias test="artisan dump-autoload && artisan clear-compiled && phpunit --debug"
alias pf="phpunit --debug --filter "
alias pu="phpunit"
alias cda="php artisan dump-autoload"
alias cu="composer update"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"
alias quickserver="python -m SimpleHTTPServer"
alias lines="find . -name '*.php' | xargs wc -l" # count php line numbers in dir
alias ma="git pull origin develop" # merge alert!
alias storage="sudo chmod -R 777 app/storage public/assets/builds; echo 'done'"
alias spfupdate="cd ~/.spf13-vim-3 && git pull && cd -"
alias profile="source ~/.profile"
alias cat="pygmentize -g" # colorizes cat
alias tags="ctags -R --fields=+aimS --languages=php --PHP-kinds=+cf 2>/dev/null"
alias orig="find . -name '*.orig' -delete" # delete .orig files
alias conflicts="grep -lir '<<<<<' *"

# phpunit with notification
function phpunitnotify () {
    /usr/local/php5/bin/phpunit $@
    if [[ $? == 0 ]]; then
        terminal-notifier -message "PHPUnit tests passed" -title "Passed" -activate "com.apple.Terminal";
    else
        terminal-notifier -message "PHPUnit tests failed" -title "Failed" -activate "com.apple.Terminal";
    fi
}
function mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# add to path
if [ -f /usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux ]; then
    PATH=$PATH:/usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux
fi
if [ -f ~/.bin ]; then
    PATH=$PATH:~/.bin
fi
export PATH

# more environment vars
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export CLICOLOR=1
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# get bash git completion
# source /usr/local/etc/bash_completion.d/git-prompt.sh
if [ -f /usr/local/etc/bash_completion ]; then
  . /usr/local/etc/bash_completion
fi
if [ -f /usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux ]; then
    source /usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux
fi

# make prompt look like this, with colors: 12:11:28 Sites $
# export PS1="$HFWHT$BBLE \T $RS$HFWHT$HBBLE \W $RS$HFWHT$BBLE $BRED$(__git_ps1 "(%s)")$RS \$ $RS "
# export PS1="\W $(__git_ps1) \$"
# export PS1="\h:\W \u\$(__git_ps1 \" (%s) \")\$ "

# set vim as default editor
if [ -f $HOME/Applications/MacVim.app/Contents/MacOS/Vim ]; then
    export EDITOR="$HOME/Applications/MacVim.app/Contents/MacOS/Vim"
fi

# add to manpath for ranger manual to show up
if [ -f $MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man ]; then
    export MANPATH=$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man
fi

# always cd into web root
# cd ~/Sites/einstein2/

# powerline shell
if [ -f $HOME/.dotfiles/powerline-shell/powerline-shell.py ]; then
    function _update_ps1() {
        export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $?)"
    }
    export PROMPT_COMMAND="_update_ps1"
fi

# generic colorizer
if [ -f /usr/local/etc/grc.bashrc ]; then
    source "/usr/local/etc/grc.bashrc"
fi

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# drops and creates einstein2 database
function dbreset() {
    # drop database, create database
    echo drop database
    mysql -uroot -e 'DROP DATABASE IF EXISTS einstein2;'

    echo create database
    mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS einstein2;'

    # migrate database, seed database
    php artisan migrate
    php artisan db:seed
}

# http://www.reddit.com/r/commandline/comments/1j7y16/handy_bash_function_i_just_wrote_to_move_up/
up() {
    echo $(pwd)

    if [[ $1 == "" ]]
        then
            newdir=/
        else
            local newdir=$(dirname $(pwd))
    fi

    while [[ "$(basename $newdir)" != *$1* ]] && [[ "$(basename $newdir)" != "/" ]]
    do
        newdir=$(dirname $newdir)
    done

    echo $newdir
    cd $newdir
}
