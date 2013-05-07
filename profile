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

# get bash git completion
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh
if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

# make prompt look like this, with colors: 12:11:28 Sites $ 
# export PS1="$HFWHT$BBLE \T $RS$HFWHT$HBBLE \W $RS$HFWHT$BBLE $BRED$(__git_ps1 "(%s)")$RS \$ $RS "
# export PS1="\W $(__git_ps1) \$"
export PS1="\h:\W \u\$(__git_ps1 \" (%s) \")\$"

export EDITOR='vim'

# add to manpath
export MANPATH=$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man

# for ranger colors to be right
# export TERM='screen-256color'

# always cd into web root
cd ~/Sites/einstein2/

# powerline shell
# function _update_ps1() {
   # export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $?)"
# }
# export PROMPT_COMMAND="_update_ps1"

# for tmux-powerline
# PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'
