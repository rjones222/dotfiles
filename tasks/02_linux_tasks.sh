#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function linux_tasks_init() {
    task_setup "linux_tasks" "Linux Tasks" "Execute tasks only if on Linux"
}

function linux_tasks_run() {

    # Linux only
    if [[ "$(type -P apt-get)" ]]; then

        # so easy!
        # fails on the first task - apt-cache
        # @link https://rtcamp.com/easyengine/
        # if [[ ! "$(type -P php)" ]]; then
            # log_info "installing EasyEngine"
            # curl -sL rt.cx/ee | sudo bash
            # sudo ee system install
        # fi

        # install linux packages
        log_info "Installing apt-get Packages"

        # latest php
        sudo apt-get -y install python-software-properties
        sudo add-apt-repository -y ppa:ondrej/php5

        # latest vim
        sudo add-apt-repository -y ppa:fcwu-tw/ppa

        # latest git
        sudo add-apt-repository -y ppa:git-core/ppa

        sudo apt-get update

        packages=(
        # ack
        apache2
        bison
        build-essential
        cloc
        cronolog
        ctags
        imagemagick
        # g++
        git
        git-extras
        # git-flow
        grc
        # hg
        highlight
        htop
        irssi
        libapache2-mod-php5
        libsqlite3-dev
        make
        multitail
        # openjdk-7-jre
        # openssh-client
        # openssh-server
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
        silversearcher-ag
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

        # install massren
        if [[ ! "$(type -P massren)" ]]; then
            log_info "installing massren"
            curl -O https://raw.github.com/laurent22/massren/master/install/install.linux-amd64.sh
            sudo bash install.linux-amd64.sh
        fi

        # install battery script
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

        if [[ ! "$(type -P tmate)" ]]; then
            log_info "installing tmate"
            sudo apt-get install python-software-properties && \
            sudo add-apt-repository -y ppa:nviennot/tmate   && \
            sudo apt-get update                             && \
            sudo apt-get install -y tmate
        fi

        # install fasd
        # if [[ ! "$(type -P fasd)" ]]; then
            # log_info "installing fasd"
            # cd ~
            # git clone https://github.com/clvv/fasd.git
            # cd fasd
            # sudo make install
            # cd ..
            # rm -rf fasd
        # fi

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
            wget "https://github.com/shawncplus/phpcomplete.vim/blob/master/misc/ctags-better-php-parser.tar.bz2?raw=true" -O ctags-better-php-parser.tar.bz2
            tar xvjf ctags-better-php-parser.tar.bz2
            cd ctags
            ./configure
            make
            sudo make install
            sudo touch /usr/local/etc/.ctags_patched_installed
            cd ..
            sudo rm ctags-better-php-parser.tar.bz2
            sudo rm -rf ctags
        fi

        # install ngrok
        if [[ ! "$(type -P ngrok)" ]]; then
            log_info "Installing ngrok"
            cd
            wget https://dl.ngrok.com/linux_386/ngrok.zip
            unzip ngrok.zip
            sudo mv ngrok /usr/local/bin/ngrok
            sudo chmod +x /usr/local/bin/ngrok
            sudo rm ngrok.zip
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
    return ${E_SUCCESS}
}
