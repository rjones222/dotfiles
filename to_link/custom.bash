#!/usr/bin/env bash

# environment vars
export ANT_ARGS='-logger org.apache.tools.ant.listener.AnsiColorLogger'
export CLICOLOR=1
if [[ $(type -p mvim) ]]; then
    export EDITOR='mvim -v'
else
    export EDITOR='vim'
fi

# virtualbox
if [ -d /Applications/VirtualBox.app/Contents/MacOS/ ]; then
    export PATH="/Applications/VirtualBox.app/Contents/MacOS:$PATH"
fi

# phpbrew
if [ -f ~/.phpbrew/bashrc ]; then
    export PHPBREW_SET_PROMPT=1
    source ~/.phpbrew/bashrc
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

