cite 'about-alias'
about-alias 'custom aliases'

# web root
alias wr='cd ~/Sites'

# commit and sync
alias updates='git add -A; git commit -am "updates"; git pull && git push'

# apache restart
alias ares="sudo apachectl restart"

# json pretty print
alias json="python -mjson.tool"

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
alias :pwd="pwd"
alias :cd="cd"
alias :so="source"
alias mux="tmuxinator"
alias artisan="php artisan"
alias migrate="php artisan migrate:refresh --seed"

# use macvim executable in terminal mode
if [ -f "/usr/local/bin/mvim" ]; then
    alias vim="mvim -v -p --servername mikefunk" 
else
    alias vim="vim -p"
fi

# alias hub to git
if [ -f "/usr/local/bin/hub" ]; then
    eval "$(hub alias -s)" 
fi

# shortcuts
alias g="git"
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

# merge alert!
alias ma="git pull origin develop" 

alias storage="sudo chmod -R 777 app/storage public/assets/builds; echo 'done'"

# updates spf-13-vim
alias spfupdate="cd ~/.spf13-vim-3 && git pull && cd -"
alias profile="source ~/.bash_profile"

#restart networking
alias restart-networking="sudo /etc/init.d/networking stop; sleep 2; sudo /etc/init.d/networking start"

# colorize cat
chk=''
if which gem >/dev/null; then
    gem list pygmentize -i | $chk
fi
if [ $chk ]; then
    alias cat="pygmentize -g"
fi


# delete .orig files
alias orig="find . -name '*.orig' -delete" 

alias tags="ctags -R --fields=+aimS --languages=php --PHP-kinds=+cf 2>/dev/null"

# grep for merge conflicts
alias conflicts="grep -lir '<<<<<' *"

# tmux
alias new-work="tmux new-session -s Work"
alias attach-work="tmux attach -t Work"
alias work="tmux attach -t Work || tmux new-session -s Work"

# create any dirs in path
alias mkdir='mkdir -pv'

# mount human readable
alias mount='mount |column -t'

# resume wget by default
alias wget='wget -c'

# brew upgrade
alias brewupdate='brew update && brew upgrade'
