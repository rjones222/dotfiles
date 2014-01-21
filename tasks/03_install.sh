#!/usr/bin/env bash

function install_init() {
    task_setup "install" "Install Tasks" "Install these on any system" "setup"
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
    yo
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo npm install -g $package
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

    if [[ ! "$(type -P gem)" ]]; then
        log_error "gem utility not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Gems"
    packages=(
    bundler
    jekyll
    kramdown
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

    # install phpctags
    hash phpctags 2>/dev/null || {
        log_info "installing phpctags"
        cd ~/.dotfiles/support/phpctags
        make
        sudo ln -s ~/.dotfiles/support/phpctags/phpctags /usr/local/bin/phpctags
        sudo chmod +x /usr/local/bin/phpctags
        cd -
    }

    # install phpenv
    if [[ ! -d ~/.phpenv ]]; then
        log_info "installing phpenv"
        git clone git://github.com/phpenv/phpenv.git ~/.phpenv
    fi

    return ${E_SUCCESS}
}
