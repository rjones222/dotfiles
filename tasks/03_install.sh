#!/usr/bin/env bash

function install_init() {
    task_setup "install" "Install Tasks" "Install cli tools" "setup"
    . ~/.dotfiles/support/install_functions.sh
}

function install_run() {
    # install npm packages
    if [[ ! "$(type -P npm)" ]]; then
        log_error "npm not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing npm Packages"
    # yo includes grunt and bower
    packages=(
    csslint
    jshint
    jsonlint
    less
    log.io
    tldr
    yo
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo npm install -g $package --user "$(whoami)"
        }
    done

    # install pear packages
    if [[ ! "$(type -P pear)" ]]; then
        log_error "pear not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Pear Packages"
    sudo pear config-set auto_discover 1
    packages=(
    pear.phpqatools.org/phpqatools
    )
    for package in "${packages[@]}"
    do
        # if [[ ! "$(type -P $package)" ]]; then
            # log_info "installing $package"
            sudo pear install $package
        # fi
    done

    # set default phpcs standard
    phpcs --config-set default_standard psr2

    # install composer
    if [[ ! "$(type -P composer)" ]]; then
        log_info "Installing Composer"
        cd
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x composer
        cd -
    fi

    # install laravel installer
    if [[ ! "$(type -P laravel)" ]]; then
        log_info "Installing Laravel Installer"
        cd
        wget http://laravel.com/laravel.phar
        sudo mv laravel.phar /usr/local/bin/laravel
        sudo chmod +x laravel
        cd -
    fi

    # install gems
    if [[ ! "$(type -P gem)" ]]; then
        log_error "gem utility not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Gems"
    packages=(
    bundler
    execjs
    jekyll
    kramdown
    pre-commit
    puppet
    pygmentize
    rdiscount
    watch
    tmuxinator
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo gem install $package
        }
    done

    # install python packages
    if [[ ! "$(type -P easy_install)" ]]; then
        log_error "easy_install not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Python packages"

    # install pip
    sudo easy_install pip

    packages=(
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo pip install $package
        }
    done

    return ${E_SUCCESS}
}
