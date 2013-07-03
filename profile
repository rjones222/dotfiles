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
alias ctags="ctags -R --exclude=*.js"
alias test="phing dump-cache && phpunit --debug"
alias pf="phpunit --debug --filter "

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
export EDITOR='vim'

# add to manpath for ranger manual to show up
export MANPATH=$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man

# always cd into web root
cd ~/Sites/einstein2/

# powerline shell
function _update_ps1() {
   export PS1="$(~/.dotfiles/powerline-shell/powerline-shell.py $?)"
}
export PROMPT_COMMAND="_update_ps1"

# generic colorizer
source "`brew --prefix`/etc/grc.bashrc"

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'
