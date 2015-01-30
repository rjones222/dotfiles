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

# alias c='clear'
alias k='clear'
alias cls='clear'

alias edit="$EDITOR"
alias pager="$PAGER"

alias q='exit'

IRC_CLIENT='irssi'
alias irc="$IRC_CLIENT"

alias rb='ruby'

# cd {{{
alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up three directories
alias -- -='cd -'        # Go back
# }}}

# Shell History {{{
alias h='history'
# }}}

# Tree {{{
if [ ! -x "$(which tree 2>/dev/null)" ]
then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi
# }}}

# Directory {{{
alias	md='mkdir -p'
alias	rd='rmdir'
# }}}

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

# My Aliases {{{

# web root
alias wr='cd ~/Sites'

# git {{{
# commit and sync
alias gitupdates='git add --all .; git commit -am "updates"; git pull && git push'
alias dotupdates='cd ~/.dotfiles; gitupdates; cd -'
alias blogupdates='cd ~/Sites/mikedfunk.github.io; gitupdates; cd -'
alias working='git add --all .; git commit -am "rebase me!!"'
alias git-root='cd $(git rev-parse --show-toplevel)'
alias gr='git-root'
# }}}

# use xdebug on the command line
PHPX="php -dxdebug.profiler_enable=1 -dxdebug.remote_autostart=On -dxdebug.idekey=netbeans-xdebug"
alias phpx="$PHPX"

# phpunit {{{
# xdebug and phpunit sitting in a tree
# alias pux="phpx `which phpunit`"
PHPUNIT="$(which phpunit)"
alias pux="$PHPX $PHPUNIT"
alias puxf="$PHPX $PHPUNIT --filter "
alias pud="phpunit --debug"
# phpunit watch
# alias puw="echo 'listening for file changes to run phpunit...' && observr ~/.dotfiles/support/observr/phpunit_observr.rb"
# alias puw="watchy -w packages -- 'clear && ~/.dotfiles/support/observr/phpunit_notify.sh'"
alias puw="phpunit-watchr"
# }}}

# phpspec {{{
alias psr="phpspec run"
alias psd="phpspec describe"
# }}}

# A function I have defined... I keep forgetting - upgrades or updates?
alias updates="upgrades"

# apache restart
alias ares="echo 'restarting apache' && sudo apachectl restart && echo 'apache restarted'"

# force color version of tree
alias tree="tree -C"

# ranger
alias rr="ranger"

# json pretty print
# alias json="python -mjson.tool"

# jekyll build via bundle
# serve, build, and watch for changes, all at once!
alias blogbuild="bundle exec jekyll server"

# I tend to forget the syntax for this
alias apt-get-search="apt-cache search"

# history search
alias hs='history | grep --color=auto'

# view apache error logs
alias logs="tac /var/log/apache2/error.log | less"

# fix terminal output error
alias gitk='gitk 2>/dev/null'

# php 5.4 built-in web server
alias phpserver='php -S localhost:8000'

# php-cs-fixer
alias pcf='php-cs-fixer fix'

 # additional details
alias lsd="ls -GpFha"

# I forget I'm not in vim sometimes...
alias :q="exit"
alias :e="vim"
alias :pwd="pwd"
alias :cd="cd"
alias :so="source"

# php, etc
alias artisan="php artisan"
alias art="php artisan"
alias migrate="php artisan migrate:refresh --seed"
alias pearupgrade="sudo pear upgrade"

# use macvim executable in terminal mode
if [ -f "/usr/local/bin/mvim" ]; then
    # servername is for united-front
    vim="mvim -vp"
else
    vim="vim -p"
fi
alias vim="${vim}"
alias v="${vim}"

# alias hub to git
if [ -f "/usr/local/bin/hub" ]; then
    eval "$(hub alias -s)"
fi

# shortcuts
alias g="git"

# phpunit {{{
# alias phpunit="phpunitnotify"
alias coverage="phpunit --debug && open build/coverage/index.html"
# alias test="php artisan test "
alias pf="phpunit --debug --filter "
alias pu="phpunitnotify"
alias pux="php -dxdebug.profiler_enable=1 -dxdebug.remote_autostart=On -dxdebug.idekey=netbeans-xdebug phpunit"
alias puf="phpunit --filter "
# }}}

# composer {{{
# composer with hhvm makes it way faster
if [[ "$(type -P hhvm)" ]]; then
    alias composer="hhvm -v ResourceLimit.SocketDefaultTimeout=30 -v Http.SlowQueryThreshold=30000 /usr/local/bin/composer"
fi
alias cda="composer dump-autoload"
alias cu="composer update"
alias ci="composer install --prefer-dist"
alias cinst="composer install --prefer-dist"
alias cgu="composer global update"
alias cgi="composer global install"
alias cgr="composer global require"
alias cgrd="composer global require --dev"
alias cs="php app/console"
alias cr="composer require"
alias crd="composer require --dev"
# alias cpt="codecept"
# alias cept="codecept"
# alias cr="codecept run"
alias com="composer"
alias c="composer"
# }}}

# alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"
# alias quickserver="python -m SimpleHTTPServer"

# behat {{{
alias b="behat"
alias bi="behat --init"
alias bas="behat --append-snippets --dry-run"
# }}}

# bower {{{
alias bowi="bower install --save"
alias bis="bower install --save"
alias bowid="bower install --save-dev"
alias bid="bower install --save-dev"
alias bow="bower"
# }}}

# npm {{{
alias nid="npm install --save-dev"
alias nig="npm install -g"
# }}}

# local tunnel - make localhost viewable on the web
alias localtunnel="lt --port 80"

# better YouCompleteMe install command
# alias ycminstall="DYLD_LIBRARY_PATH=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib /Users/mfunk/.vim/bundle/YouCompleteMe/install.sh --clang-completer"
alias ycminstall="cd /Users/mfunk/.vim/bundle/YouCompleteMe && git submodule update --init --recursive && ./install.sh && cd -"

# irssi nicklist in a split
alias nicklist="cat ~/.irssi/nicklistfifo"

alias myirc="irssi; tmux split-window -h"

# count php line numbers in dir
alias lines="find . -name '*.php' | xargs wc -l"

alias storage="sudo chmod -R 777 app/storage public/assets/builds; echo 'done'"

alias profile="source ~/.bash_profile && echo 'bash profile reloaded'"

# restart networking
alias restart-networking="sudo /etc/init.d/networking stop; sleep 2; sudo /etc/init.d/networking start"

# show largest directories in entire file system from current dir down
alias largestfiles="find . -type f -print0 | xargs -0 du | sort -n | tail -10 | cut -f2 | xargs -I{} du -sh {}"
alias largestdirs="find . -type d -print0 | xargs -0 du | sort -n | tail -10 | cut -f2 | xargs -I{} du -sh {}"

# colorize cat {{{
chk=''
if which gem >/dev/null; then
    gem list pygmentize -i | $chk
fi
if [ $chk ]; then
    alias cat="pygmentize -g"
fi
# }}}

# HEMING!!!!!!!!!!
alias freakingwindows='find . -not -type d -exec file "{}" ";" | grep CRLF'
# i now use homebrew package instead, so disabling this
# alias dos2unix='grep -URl  . | xargs fromdos'

# delete .orig files
alias orig="find . -name '*.orig' -delete"

alias tags="echo 'generating tags file...' && ctags 2>/dev/null && echo 'tags file regenerated'"

# grep for merge conflicts
alias conflicts="grep -lir '<<<<<' *"
alias grep="grep --color=auto"

# tmux session for work
alias work="tmux -2 -u -S /tmp/pair attach -t Work || (tmux -2 -u -S /tmp/pair new -d -s Work && chmod 777 /tmp/pair && tmux -2 -u -S /tmp/pair attach)"
alias home="tmux -2 -u attach -t Home || (tmux -2 -u new -d -s Home && tmux -2 -u attach)"
alias layout="teamocil work --here"

# create any dirs in path
alias mkdir='mkdir -pv'

# mount human readable
alias mount='mount |column -t'

# resume wget by default
alias wget='wget -c'

# brew upgrade
alias brewup='brew update && brew upgrade'

# use grc to add pretty colors to commands
alias ping='grc ping'
alias tail='grc tail'
alias traceroute='grc traceroute'
alias cat="grc cat"
alias make="grc make"
alias rake="grc rake"
alias netstat="grc netstat"
alias diff="grc diff"

# copy ssh key
alias sshkey="cat ~/.ssh/id_rsa.pub | pbcopy && echo 'Copied to clipboard.'"

# use autossh instead of ssh
alias ssh="autossh"
# ssh-copy-id with pub key file and auto-accept new server pub keys
alias sci="ssh-copy-id -i ~/.ssh/keys/demandmedia.pub -o StrictHostKeyChecking=no"

# install the vaprobash vagrant file here
alias vaprobash='curl -L http://bit.ly/vaprobash > Vagrantfile'
alias vpro='vagrant provision'
alias vdst='vagrant destroy'

# symfony console
alias sc='php app/console'

# remove folder
alias rmf='rm -rf'

# release and renew ip address on mac
alias renewip="sudo ipconfig set en0 BOOTP && sudo ipconfig set en0 DHCP && echo 'ip renewed'"

# mac flush dns
# macos 10.6 snow leopard
# alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && echo 'dns flushed'"
# mountain lion or lion
# alias flushdns="sudo killall -HUP mDNSResponder && echo 'dns flushed'"
# yosemite
alias flushdns="sudo discoveryutil mdnsflushcache && sudo discoveryutil udnsflushcaches && echo 'dns flushed'"

# phing
alias ph="phing"

# pushd and popd are useful for saving bookmarks in cd! random reminder.

# use netextender to connect to vpn
alias vpn="yes | netExtender --auto-reconnect -u $VPNUSERNAME -p $VPNPASSWORD -d $VPNDOMAIN $VPNURL"
# alias vpn="netExtender --auto-reconnect -u $VPNUSERNAME -d $VPNDOMAIN $VPNURL"

# daily standup notes named by date
alias standupnotes="tmux rename-window 'standup' && vim ~/Google\ Drive/standup/`date +%F`.markdown"

alias acpcore="cd ~/Sites/acp-core"
alias acphrh="cd ~/Sites/acp-hotrodhotline"

# shortcut to vhosts file on mac
alias vhosts="vim /etc/apache2/extra/httpd-vhosts.conf"

# }}}
