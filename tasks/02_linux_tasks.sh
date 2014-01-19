#!/usr/bin/env bash

function linux_tasks_init() {
    task_setup "linux_tasks" "Linux Tasks" "Execute tasks only if on Linux" "setup"
}

function linux_tasks_run() {
    # Linux only
    if [[ "$(type -P apt-get)" ]]; then

        # install linux packages
        log_info "Installing apt-get Packages"

        packages=(
        openjdk-7-jre
        git
        git-core
        openssh-client
        openssh-server
        postfix
        cronolog
        apache2
        imagemagick
        postgresql
        postgresql-contrib
        pgadmin3
        php5
        libapache2-mod-php5
        php5-xdebug
        php5-imagick
        php-apc
        php5-cli
        php5-pgsql
        php5-curl
        vim
        ack
        ctags
        git-extras
        grc
        highlight
        htop
        irssi
        php5-json
        php-pear
        postgresql
        rake
        silversearcher-ag
        solr-tomcat
        tmux
        tree
        python-software-properties
        python
        g++
        make
        )
        for package in "${packages[@]}"
        do
            hash $package 2>/dev/null || {
                log_info "installing $package"
                sudo apt-get install $package -y
            }
        done

        # install npm for ubuntu 13.04 64 bit
        if [[ ! "$(type -P npm)" ]]; then
            log_info "installing nodejs"
            sudo apt-get install python-software-properties python g++ make
            sudo add-apt-repository ppa:chris-lea/node.js
            sudo apt-get update
            sudo apt-get install -y nodejs
        fi

        # install rbenv
        if [[ ! "$(type -P rbenv)" ]]; then
            log_info "Installing rbenv"
            curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
        fi

        if [[ ! "$(type -P rake)" ]]; then
            log_error "rake not installed"
            return ${E_FAILURE}
        fi

        # install github's hub
        if [[ ! "$(type -P hub)" ]]; then
            log_info "Installing hub"
            cd ~/.dotfiles/hub
            sudo rake install
        fi

    fi
    return ${E_SUCCESS}
}
