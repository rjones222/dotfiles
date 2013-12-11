# pretty colors
GREEN=$(tput setaf 2)
RESET=$(tput setaf 0)

# add to path
if [ -d "/usr/local/bin" ] ; then
    export PATH="/usr/local/bin:$PATH"
fi

if [ -d "$HOME/.rbenv/bin" ] ; then
    export PATH="$HOME/.rbenv/bin:$PATH"
fi
eval "$(rbenv init -)"

if [ -f "/usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux" ]; then
    export PATH="/usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux:$PATH"
fi
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.bin" ] ; then
    export PATH="$HOME/.bin:$PATH"
fi
# add ruby gems to PATH
if [ -f "/usr/local/bin/brew" ]; then
    export PATH=$(brew --prefix ruby)/bin:$PATH
fi

# ----------------------------------
# aliases

alias wr='cd ~/Sites' # web root
alias updates='git pull && git commit -am "updates"; git pull; git push'

# json pretty print
alias json="python -mjson.tool"

#history search
alias hs='history | grep --color=auto'

# view apache error logs
alias logs="tac /var/log/apache2/error.log | less"

# for virtualbox
alias mountwww='mount -t vboxsf ubuntubox /var/www'

# fix terminal output error
alias gitk='gitk 2>/dev/null'

alias vimupdate='vim +BundleClean! +qall && vim +BundleInstall! +qall'
alias viminstall='vim +BundleClean! +qall && vim +BundleInstall +qall'

 # additional details
alias lsd="ls -GpFha"

# I forget I'm not in vim sometimes...
alias :q="exit"
alias :pwd="pwd"
alias :cd="cd"
alias :so="source"
alias mux="tmuxinator"
alias artisan="php artisan"
alias migrate="php artisan migrate:refresh --seed"

# use macvim executable in terminal mode
if [ -f "/usr/local/bin/mvim" ]; then
    alias vim="mvim -v --servername mikefunk" 
fi

# alias hub to git
if [ -f "/usr/local/bin/hub" ]; then
    eval "$(hub alias -s)" 
fi

alias g="git"
alias coverage="phpunit --debug && open build/coverage/index.html"
alias test="php artisan test "
alias pf="phpunit --debug --filter "
alias pu="phpunit"
alias cda="composer dump-autoload"
alias cu="composer update"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"
alias quickserver="python -m SimpleHTTPServer"

# count php line numbers in dir
alias lines="find . -name '*.php' | xargs wc -l" 

# merge alert!
alias ma="git pull origin develop" 

alias storage="sudo chmod -R 777 app/storage public/assets/builds; echo 'done'"
alias spfupdate="cd ~/.spf13-vim-3 && git pull && cd -"
alias profile="source ~/.profile"
alias resetnet="sudo /etc/init.d/networking stop; sleep 2; sudo /etc/init.d/networking start"

# end aliases
# --------------------------------

# colorize cat
chk=''
if which gem >/dev/null; then
    gem list pygmentize -i | $chk
fi
if [ $chk ]; then
    alias cat="pygmentize -g"
fi

alias tags="ctags -R --fields=+aimS --languages=php --PHP-kinds=+cf 2>/dev/null"
alias orig="find . -name '*.orig' -delete" # delete .orig files
alias conflicts="grep -lir '<<<<<' *"
alias new-work="tmux new-session -s Work"
alias attach-work="tmux attach -t Work"

# phpunit with notification
phpunitnotify () {
    /usr/local/php5/bin/phpunit "${@}"
    if [[ $? == 0 ]]; then
        terminal-notifier -message "PHPUnit tests passed" -title "Passed" -activate "com.apple.Terminal";
    else
        terminal-notifier -message "PHPUnit tests failed" -title "Failed" -activate "com.apple.Terminal";
    fi
}
mkdircd () { mkdir -p "$@" && eval cd "\"\$$#\""; }

# more environment vars
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export CLICOLOR=1

# get bash git completion
if [ -f "/usr/local/etc/bash_completion" ]; then
  . /usr/local/etc/bash_completion
fi
if [ -f "/usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux" ]; then
    source /usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux
fi

# git ps1 prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

# set vim as default editor
if [ -f "$HOME/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
    export EDITOR="$HOME/Applications/MacVim.app/Contents/MacOS/Vim"
elif [ -f "/Applications/MacVim.app/Contents/MacOS/Vim" ]; then
    export EDITOR="$HOME/Applications/MacVim.app/Contents/MacOS/Vim"
else
    export EDITOR="vim"
fi

# add to manpath for ranger manual to show up
if [ -f "$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man" ]; then
    export MANPATH=$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man
fi

# git line for ps1
# @link http://stackoverflow.com/questions/4485059/git-bash-is-extremely-slow-in-windows-7-x64
fast_git_ps1 () {
    printf -- "$(tput setab 4)$(tput setaf 7)$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ \1 /')"
}

# ---------------------------------
# custom ps1
_my_ps1 () {
    # check non-zero exit status
    local EXIT="$?"

    # start with white fg
    PS1="$(tput setaf 7)"

    # set some background color vars
    local RED="$(tput setab 1)"
    local GREEN="$(tput setab 2)"
    local GRAY="$(tput setab 14)"

    # gray path, git in blue if there is a git repo
    PS1+="$GRAY \w $(fast_git_ps1)"

    # red if non-zero exit status, otherwise green
    if [ $EXIT != 0 ]; then
        PS1+="$RED"
    else
        PS1+="$GREEN"
    fi

    # ssh text
    if [ -n "$SSH_CLIENT" ]; then PS1+=" ssh"
    fi

    # reset
    PS1+=" \$ $(tput sgr0) "
}
export PROMPT_COMMAND="_my_ps1"

# end ps1
# ---------------------------------

# generic colorizer
if [ -f /usr/local/etc/grc.bashrc ]; then
    source "/usr/local/etc/grc.bashrc"
fi

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# drops and creates einstein2 database
dbreset() {

    # drop database, create database
    echo "${GREEN}drop database${RESET}"
    mysql -uroot -e 'DROP DATABASE IF EXISTS einstein2;'

    echo "${GREEN}create database${RESET}"
    mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS einstein2;'

    # migrate database, seed database
    php artisan migrate
    php artisan db:seed
}
