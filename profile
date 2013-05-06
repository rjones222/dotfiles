alias wr='cd ~/Sites'
alias selenium='java -jar /usr/local/bin/selenium-server.jar'
alias gitk='gitk 2>/dev/null'
alias vimupdate='vim +BundleClean! +qall && vim +BundleInstall! +qall'
alias watch='observr ~/.dotfiles/observr.conf.rb'
alias ls="ls -GpFha"
alias :q="exit"
alias artisan="php artisan"
alias :pwd="pwd"

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
export PATH
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export CLICOLOR=1
# export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# colorize grep
export GREP_OPTIONS="–color=auto"
export GREP_COLOR="1;35;40"

export PS1="\[\e[32m\]\T\[\e[0m\] \[\e[33m\]\W\[\e[0m\] \$ "

# for tmux-powerline
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

export EDITOR='vim'

# for ranger colors to be right
export TERM='screen-256color'

# always cd into web root
cd ~/Sites
