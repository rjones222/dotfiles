alias wr='cd ~/Sites'
alias selenium='java -jar /usr/local/bin/selenium-server.jar'
alias gitk='gitk 2>/dev/null'
alias vimupdate='vim +BundleClean! +qall && vim +BundleInstall! +qall'
alias watch='observr ~/.dotfiles/observr.conf.rb'
alias ls="ls -GpFha"
alias :q="exit"
alias artisan="php artisan"
alias :pwd="pwd"
alias :cd="cd"
alias :so="source"
alias mux="tmuxinator"
alias migrate="php artisan migrate:refresh --seed"
alias vim="mvim -v"
alias e2='cd ~/Sites/einstein2'
# alias hub to git
eval "$(hub alias -s)"
alias g="git"
alias coverage="phpunit --debug && open build/coverage/index.html"
alias ctags="ctags -R --fields=+aimS --languages=php --PHP-kinds=+cf"
alias test="phing dump-cache && phpunit --debug"
alias pf="phpunit --debug --filter "
alias cda="php artisan dump-autoload"
alias cu="composer update"
alias quickserver="python -m SimpleHTTPServer"
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias myip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"

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
PATH=$PATH:/Applications/VirtualBox.app/Contents/MacOS
PATH=$PATH:~/.bin
PATH=$PATH:vendor/bin
export PATH
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export CLICOLOR=1
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# get bash git completion
# source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi
source $(brew --prefix)/Cellar/tmux/1.8/etc/bash_completion.d/tmux

# make prompt look like this, with colors: 12:11:28 Sites $ 
# export PS1="$HFWHT$BBLE \T $RS$HFWHT$HBBLE \W $RS$HFWHT$BBLE $BRED$(__git_ps1 "(%s)")$RS \$ $RS "
# export PS1="\W $(__git_ps1) \$"
# export PS1="\h:\W \u\$(__git_ps1 \" (%s) \")\$ "

# set vim as default editor
export EDITOR="$HOME/Applications/MacVim.app/Contents/MacOS/Vim"

# add to manpath for ranger manual to show up
export MANPATH=$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man

# always cd into web root
# cd ~/Sites/einstein2/

# powerline shell
function _update_ps1() {
   export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $?)"
}
export PROMPT_COMMAND="_update_ps1"

# generic colorizer
source "`brew --prefix`/etc/grc.bashrc"

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# drops and creates einstein2 database
function dbreset() {
    # drop database
    echo drop database
    mysql -uroot -e 'drop database einstein2;'

    # create database
    echo create database
    mysql -uroot -e 'create database einstein2;'

    # migrate database
    php artisan migrate

    # seed database
    php artisan db:seed
}

# http://www.reddit.com/r/commandline/comments/1j7y16/handy_bash_function_i_just_wrote_to_move_up/
# I was working on some source with a deep directory structure, so wrote this 
# little function to help in going up a few levels.
# Instead of having to do "cd../../../../../" over and over!
# You just type "up dirname" and it changes to the first parent directory that 
# contains dirname, or to "/" if not found. Haven't tested it extensively yet, so 
# likely to not work in all situations!
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
