#!/usr/bin/env bash

# ----------------------------------------
# custom

# environment vars
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export CLICOLOR=1
if [[ $(type -p mvim) ]]; then
    export EDITOR='mvim -v'
else
    export EDITOR='vim'
fi

# add to path
if [ -d "/usr/local/bin" ] ; then
    export PATH="/usr/local/bin:$PATH"
fi

# phpenv
if [ -d "$HOME/.phpenv/bin" ] ; then
    export PATH="$HOME/.phpenv/bin:$PATH"
fi

# rbenv
export RBENV_ROOT="${HOME}/.rbenv"
if [ -d "${RBENV_ROOT}" ]; then
  export PATH="${RBENV_ROOT}/bin:${PATH}"
  eval "$(rbenv init -)"
fi

# tmux bash completion
if [ -f "/usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux" ]; then
    export PATH="/usr/local/Cellar/tmux/1.8/etc/bash_completion.d/tmux:$PATH"
fi
# get bash git completion
if [ -f "/usr/local/etc/bash_completion" ]; then
  . /usr/local/etc/bash_completion
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    export PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.bin" ] ; then
    export PATH="$HOME/.bin:$PATH"
fi

# if homebrew installed
if [ -f "/usr/local/bin/brew" ]; then

    # add ruby gems to PATH
    export PATH=$(brew --prefix ruby)/bin:$PATH

    # source homebrew bash completion
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi

# add to manpath for ranger manual to show up
if [ -f "$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man" ]; then
    export MANPATH=$MANPATH:/usr/local/Cellar/python/2.7.4/Frameworks/Python.framework/Versions/2.7/share/man
fi

# generic colorizer
if [ -f /usr/local/etc/grc.bashrc ]; then
    source "/usr/local/etc/grc.bashrc"
fi

# Tell grep to highlight matches
export GREP_OPTIONS='--color=auto'

# ----------------------------------------
# custom ps1

# git ps1 prompt
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1

# git line for ps1
# @link http://stackoverflow.com/questions/4485059/git-bash-is-extremely-slow-in-windows-7-x64
fast_git_ps1 () {
    printf -- "$(tput setab 4)$(tput setaf 7)$(git branch 2>/dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ \1 /')"
}

_my_ps1 () {
    # check non-zero exit status
    local EXIT="$?"

    # start with white fg
    # PS1="\["
    PS1=""
    PS1+="\[$(tput setaf 7)\]"

    # set some background color vars
    local RED="$(tput setab 1)"
    local GREEN="$(tput setab 2)"
    local GRAY="$(tput setab 6)"

    # gray path, git in blue if there is a git repo
    PS1+="\[$GRAY\] \w \[$(fast_git_ps1)\]"

    # red if non-zero exit status, otherwise green
    if [ $EXIT != 0 ]; then
        PS1+="\[$RED\]"
    else
        PS1+="\[$GREEN\]"
    fi

    # ssh text
    if [ -n "$SSH_CLIENT" ]; then PS1+=" ssh"
    fi

    # reset
    PS1+=" \$ \[$(tput sgr0)\]"
    PS1+=" "
    # PS1+="\]"
}
export PROMPT_COMMAND="_my_ps1"
