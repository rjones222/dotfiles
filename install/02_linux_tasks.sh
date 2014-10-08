#!/usr/bin/env bash

# Linux only
if [[ "$(type -P apt-get)" ]]; then

    # install linux packages
    log_info "Installing apt-get Packages"

    # latest php
    sudo apt-get -y install python-software-properties
    sudo add-apt-repository -y ppa:ondrej/php5

    # latest vim
    sudo add-apt-repository -y ppa:fcwu-tw/ppa

    # latest git
    sudo add-apt-repository -y ppa:git-core/ppa

    # update all apt-get packages
    sudo apt-get update -y

    # python 2.7
    sudo apt-get install -y python-dev

    packages=(
    # ack
    apache2
    autossh
    bison
    build-essential
    cloc
    cmake
    cronolog
    ctags
    imagemagick
    # g++
    git
    git-extras
    # git-flow
    googlecl
    grc
    # hg
    highlight
    htop
    irssi
    libapache2-mod-php5
    libsqlite3-dev
    # libxml2
    make
    multitail
    # openjdk-7-jre
    # openssh-client
    # openssh-server
    pandoc
    # pgadmin3
    php-apc
    php-pear
    php5
    php5-cli
    php5-curl
    php5-imagick
    php5-json
    php5-mcrypt
    # php5-pgsql
    php5-xdebug
    # postfix
    # postgresql
    # postgresql-contrib
    # python-software-properties
    # python-dev
    python-pip
    rake
    ranger
    # ruby1.9.1-dev
    sshuttle
    # solr-tomcat
    # spidermonkey-bin
    tig
    tmux
    tofrodos
    tree
    vim
    watch
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo apt-get install $package -y
        }
    done

    # install battery script (used on tmux statusline)
    if [[ ! "$(type -P battery)" ]]; then
        log_info "installing battery script"
        cd
        curl -O https://raw.github.com/richo/battery/master/bin/battery
        sudo mv battery /usr/local/bin/battery
        sudo chmod +x /usr/local/bin/battery
    fi

     # install the silver searcher
    if [[ ! "$(type -P ag)" ]]; then
        log_info "installing the silver searcher"
        sudo apt-get install software-properties-common # (if required)
        sudo apt-add-repository -y ppa:mizuno-as/silversearcher-ag
        sudo apt-get update
        sudo apt-get install -y silversearcher-ag
    fi

    # enable mcrypt for php
    if [[ ! -L "/etc/php5/mods-available/mcrypt.ini" ]]; then
        log_info "enabling mcrypt for php"
        sudo ln -s /etc/php5/conf.d/mcrypt.ini /etc/php5/mods-available/
        sudo php5enmod mcrypt
        sudo service apache2 restart
    fi

    # install rbenv
    if [[ ! "$(type -P rbenv)" ]]; then
        log_info "installing rbenv"
        git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    fi

    # install npm for ubuntu 13.04 64 bit
    if [[ ! "$(type -P npm)" ]]; then
        log_info "installing nodejs"
        sudo apt-get install python-software-properties python g++ make -y
        sudo add-apt-repository -y ppa:chris-lea/node.js
        sudo apt-get update
        sudo apt-get install -y nodejs
    fi

    if [[ ! "$(type -P rake)" ]]; then
        log_error "rake not installed"
        return ${E_FAILURE}
    fi

    # install github's hub
    if [[ ! "$(type -P hub)" ]]; then
        log_info "Installing hub"
        cd ~/.dotfiles/support/hub
        sudo rake install
    fi

    # install fideloper vhost
    if [[ ! "$(type -P vhost)" ]]; then
        log_info "Installing vhost tool"
        curl https://gist.github.com/fideloper/2710970/raw/vhost.sh > vhost
        sudo chmod guo+x vhost
        sudo mv vhost /usr/local/bin
    fi

    # install ctags patched
    if [[ ! -f /usr/local/etc/.ctags_patched_installed ]]; then
        log_info "Installing Ctags Patched"
        cd
        wget "https://github.com/shawncplus/phpcomplete.vim/raw/master/misc/ctags-5.8_better_php_parser.tar.gz" -O ctags-5.8_better_php_parser.tar.gz
        tar xvf ctags-5.8_better_php_parser.tar.gz
        cd ctags-5.8_better_php_parser
        ./configure
        make
        sudo make install
        sudo touch /usr/local/etc/.ctags_patched_installed
        cd ..
        sudo rm ctags-5.8_better_php_parser.tar.gz
        sudo rm -rf ctags-5.8_better_php_parser
    fi

    # install powerline fonts
    if [[ ! -d "~/.fonts/powerline-fonts" ]]; then
        log_info "installing powerline fonts"
        [ -d "$HOME/.fonts" ] || mkdir ~/.fonts
        cd ~/.fonts
        git clone https://github.com/Lokaltog/powerline-fonts
        wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf
        wget https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
        # Merge the contents of 10-powerline-symbols.conf to ~/.fonts.conf
        fc-cache -vf ~/.fonts
    fi

else
    log_error "This is not linux so not running linux tasks"
fi
