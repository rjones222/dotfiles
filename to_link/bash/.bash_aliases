#!/usr/env/bin bash

# Modeline and Notes {{{
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
#
#  ___  ____ _         ______           _
#  |  \/  (_) |        |  ___|         | |
#  | .  . |_| | _____  | |_ _   _ _ __ | | __
#  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
#  | |  | | |   <  __/ | | | |_| | | | |   <
#  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
#
# bash aliases
# more info at http://mikefunk.com
# }}}

# General {{{

# List directory contents
alias sl=ls
alias ls='ls -G'        # Compact view, show colors
alias la='ls -AF'       # Compact view, show hidden
alias ll='ls -al'
alias l='ls -a'
alias l1='ls -1'

alias _="sudo"

if [ $(uname) = "Linux" ]
then
  alias ls="ls --color=auto"
fi
which gshuf &> /dev/null
if [ $? -eq 0 ]
then
  alias shuf=gshuf
fi

alias c='clear'
alias k='clear'
alias cls='clear'

alias edit="$EDITOR"
alias pager="$PAGER"

alias q='exit'

alias irc="$IRC_CLIENT"

alias rb='ruby'

# Pianobar can be found here: http://github.com/PromyLOPh/pianobar/

alias piano='pianobar'

alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back

# Shell History
alias h='history'

# Tree
if [ ! -x "$(which tree 2>/dev/null)" ]
then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

# Directory
alias	md='mkdir -p'
alias	rd='rmdir'

# }}}

# Vim {{{

alias v='mvim --remote-tab'

# }}}

# Vagrant {{{

alias vup="vagrant up"
alias vh="vagrant halt"
alias vs="vagrant suspend"
alias vr="vagrant resume"
alias vrl="vagrant reload"
alias vssh="vagrant ssh"
alias vst="vagrant status"
alias vp="vagrant provision"
alias vdstr="vagrant destroy"
# requires vagrant-list plugin
alias vl="vagrant list"
# requires vagrant-hostmanager plugin
alias vhst="vagrant hostmanager"

# }}}

# Mac {{{

alias preview="open -a '$PREVIEW'"
alias xcode="open -a '/Applications/XCode.app'"
alias filemerge="open -a '/Developer/Applications/Utilities/FileMerge.app'"
alias safari="open -a safari"
alias firefox="open -a firefox"
alias chrome="open -a google\ chrome"
alias dashcode="open -a dashcode"
alias f='open -a Finder '
alias fh='open -a Finder .'
alias textedit='open -a TextEdit'
alias hex='open -a "Hex Fiend"'

# }}}

# Laravel {{{

# A list of useful laravel aliases

# asset
alias a:apub='php artisan asset:publish'

# auth
alias a:remclear='php artisan auth:clear-reminders'
alias a:remcontroller='php artisan auth:reminders-controller'
alias a:remtable='php artisan auth:reminders-table'

# cache
alias a:cacheclear='php artisan cache:clear'

# command
alias a:command='php artisan command:make'

# config
alias a:confpub='php artisan config:publish'

# controller
alias a:controller='php artisan controller:make'

# db
alias a:seed='php artisan db:seed'

# key
alias a:key='php artisan key:generate'

# migrate
alias a:migrate='php artisan migrate'
alias a:mig='a:migrate'
alias a:miginstall='php artisan migrate:install'
alias a:migmake='php artisan migrate:make'
alias a:migcreate='php artisan migrate:create'
alias a:migpublish='php artisan migrate:publish'
alias a:migrefresh='php artisan migrate:refresh'
alias a:migreset='php artisan migrate:reset'
alias a:migrollback='php artisan migrate:rollback'
alias a:rollback='a:migrollback'

# queue
alias a:qfailed='php artisan queue:failed'
alias a:qfailedtable='php artisan queue:failed-table'
alias a:qflush='php artisan queue:flush'
alias a:qforget='php artisan queue:forget'
alias a:qlisten='php artisan queue:listen'
alias a:qretry='php artisan queue:retry'
alias a:qsubscribe='php artisan queue:subscribe'
alias a:qwork='php artisan queue:work'

# session
alias a:stable='php artisan session:table'

# view
alias a:vpub='php artisan view:publish'

# misc
alias a:='php artisan'
alias a:changes='php artisan changes'
alias a:down='php artisan down'
alias a:env='php artisan env'
alias a:help='php artisan help'
alias a:list='php artisan list'
alias a:optimize='php artisan optimize'
alias a:routes='php artisan routes'
alias a:serve='php artisan serve'
alias a:tail='php artisan tail'
alias a:tinker='php artisan tinker'
alias a:up='php artisan up'
alias a:work='php artisan workbench'

# }}}

# Homebrew {{{

alias bup='brew update && brew upgrade'
alias bout='brew outdated'
alias bin='brew install'
alias brm='brew uninstall'
alias bls='brew list'
alias bsr='brew search'
alias binf='brew info'
alias bdr='brew doctor'
 
# }}}

# Git {{{

# Aliases
alias gcl='git clone'
alias ga='git add'
alias gall='git add .'
alias gus='git reset HEAD'
alias gm="git merge"
alias g='git'
alias get='git'
alias gst='git status'
alias gs='git status'
alias gss='git status -s'
alias gl='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull && git push'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gpo='git push origin'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -v -m'
alias gci='git commit --interactive'
alias gb='git branch'
alias gba='git branch -a'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gexport='git archive --format zip --output'
alias gdel='git branch -D'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"

case $OSTYPE in
  darwin*)
    alias gtls="git tag -l | gsort -V"
    ;;
  *)
    alias gtls='git tag -l | sort -V'
    ;;
esac

if [ -z "$EDITOR" ]; then
    case $OSTYPE in
      linux*)
        alias gd='git diff | vim -R -'
        ;;
      darwin*)
        alias gd='git diff | mate'
        ;;
      *)
        alias gd='git diff'
        ;;
    esac
else
    alias gd="git diff | $EDITOR"
fi

# }}}


