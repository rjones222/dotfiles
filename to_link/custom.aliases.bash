cite 'about-alias'
about-alias 'custom aliases'

# web root
alias wr='cd ~/Sites'

# serve port 80 on ngrok
alias ngrokserve="ngrok -subdomain=mikedfunk -authtoken CBLb8X5ikqjKSdnXcZDD 80"

# commit and sync
alias updates='git add --all .; git commit -am "updates"; git pull && git push'
alias dotupdates='cd ~/.dotfiles; updates; cd -'
alias blogupdates='cd ~/Sites/mikedfunk.github.io; updates; cd -'
alias working='git add --all .; git commit -am "working"; git pull && git push'

# apache restart
alias ares="sudo apachectl restart"

# json pretty print
alias json="python -mjson.tool"

# jekyll build via bundle
alias blogbuild="cd ~/Sites/mikedfunk.github.io/; bundle exec jekyll build; cd -"

# I tend to forget the syntax for this
alias apt-get-search="apt-cache search"

# history search
alias hs='history | grep --color=auto'

# view apache error logs
alias logs="tac /var/log/apache2/error.log | less"

# for virtualbox
alias mountwww='sudo mount -t vboxsf ubuntubox /var/www'

# fix terminal output error
alias gitk='gitk 2>/dev/null'

# update/install with vundle
alias vimupdate='vim +BundleClean! +qall && vim +BundleInstall! +qall'
alias viminstall='vim +BundleClean! +qall && vim +BundleInstall +qall'

# php 5.4 built-in web server
alias phpserver='php -S localhost:8000'

 # additional details
alias lsd="ls -GpFha"

# I forget I'm not in vim sometimes...
alias :q="exit"
alias :e="vim"
alias :pwd="pwd"
alias :cd="cd"
alias :so="source"
alias mux="tmuxinator"
alias artisan="php artisan"
alias migrate="php artisan migrate:refresh --seed"
alias pearupgrade="sudo pear upgrade"

# use macvim executable in terminal mode
if [ -f "/usr/local/bin/mvim" ]; then
    vim="mvim -vp --servername mikefunk"
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
# do git completion with g
__git_complete g __git_main
alias coverage="phpunit --debug && open build/coverage/index.html"
alias test="php artisan test "
alias pf="phpunit --debug --filter "
alias pu="phpunit"
alias cda="composer dump-autoload"
alias cu="composer update"
# alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"
# alias quickserver="python -m SimpleHTTPServer"

# count php line numbers in dir
alias lines="find . -name '*.php' | xargs wc -l" 

# run log.io server
function logio() {
    log.io-server && log.io-harvester
}

# merge alert!
alias ma="git pull origin develop"

alias storage="sudo chmod -R 777 app/storage public/assets/builds; echo 'done'"

# updates spf-13-vim
alias spfupdate="cd ~/.spf13-vim-3 && git pull && cd -"
alias profile="source ~/.bash_profile"

# pull latest upstream
alias upstream="git pull upstream master"
alias origin="git pull origin master"

#restart networking
alias restart-networking="sudo /etc/init.d/networking stop; sleep 2; sudo /etc/init.d/networking start"

# colorize cat
# chk=''
# if which gem >/dev/null; then
    # gem list pygmentize -i | $chk
# fi
# if [ $chk ]; then
    # alias cat="pygmentize -g"
# fi

# delete .orig files
alias orig="find . -name '*.orig' -delete" 

alias tags="ctags -R --exclude=.git --exclude='*.log' --fields=+aimS --languages=php --PHP-kinds=+cf 2>/dev/null"

# grep for merge conflicts
alias conflicts="grep -lir '<<<<<' *"
alias grep="grep --color=auto"

# tmux
alias new-work="tmux -2 -S /tmp/pair new-session -s Work"
alias attach-work="tmux -2 -S /tmp/pair attach -t Work"
alias work="tmux -2 -S /tmp/pair attach -t Work || tmux -2 -S /tmp/pair new-session -s Work"

# create any dirs in path
alias mkdir='mkdir -pv'

# mount human readable
alias mount='mount |column -t'

# resume wget by default
alias wget='wget -c'

# brew upgrade
alias brewupdate='brew update && brew upgrade'
alias vpn='netExtender -u mfunk -d CARSDIRECT ibhq1vpn.internetbrands.com'

# use grc to add pretty colors to commands
alias ping='grc ping'
alias tail='grc tail'
alias traceroute='grc traceroute'
alias cat="grc cat"
alias make="grc make"
alias rake="grc rake"
alias netstat="grc netstat"
alias diff="grc diff"

alias please='sudo !!'

# don't forget there are reload commands in bash_it for everything
# just type reload<tab>

# pushd and popd are useful for saving bookmarks in cd! random reminder.
