#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function install_init() {
    task_setup "install" "Install Tasks" "Install cli tools"
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
    coffeelint
    coffee-script
    csslint
    git-guilt
    gulp
    gulp-watch
    instant-markdown-d
    jshint
    jsonlint
    less
    localtunnel
    log.io
    phantomjs
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

    # install pear packages
    log_info "Installing Pear Packages"
    sudo pear config-set auto_discover 1
    packages=(
    doc.php.net/pman
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

    # composer global install
    link_this "$HOME/.dotfiles/to_link/.composer" "$HOME/.composer"
    composer global install

    # build phpctags
    if [[ ! "$(type -P phpctags)" ]]; then
        log_info "building phpctags"
        cd $HOME/.composer/vendor/techlivezheng/phpctags
        make
        cd -
    fi

    # set default phpcs standard
    if [[ "$(type -P phpcs)" ]]; then
        log_info "setting phpcs defaults"
        sudo phpcs --config-set default_standard PSR2
        sudo phpcs --config-set show_progress 1
        sudo phpcs --config-set encoding utf-8
        sudo phpcs --config-set tab_width 4
    fi

    # install bldr
    # if [[ ! "$(type -P bldr)" ]]; then
    #     log_info "Installing bldr"
    #     cd
    #     curl -sS http://bldr.io/installer | php
    #     sudo mv bldr.phar /usr/local/bin/bldr
    #     sudo chmod +x bldr
    #     cd -
    # fi

    # install bowery
    # if [[ ! "$(type -P bowery)" ]]; then
    #     log_info "installing bowery"
    #     curl -O download.bowery.io/downloads/bowery_2.2.0_darwin_amd64.zip && sudo unzip bowery_2.2.0_darwin_amd64.zip -d /usr/local/bin
    # fi

    # install pyrus
    if [[ ! "$(type -P pyrus)" ]]; then
        log_info "Installing pyrus"
        cd
        wget http://pear2.php.net/pyrus.phar
        sudo mv pyrus.phar /usr/local/bin/pyrus
        sudo chmod +x /usr/local/bin/pyrus
        cd -
    fi

    # install laravel installer
    # if [[ ! "$(type -P laravel)" ]]; then
    #     log_info "Installing Laravel Installer"
    #     sudo curl http://laravel.com/laravel.phar -o /usr/local/bin/laravel
    #     sudo chmod +x /usr/local/bin/laravel
    # fi

    # install laravel envoy
    # if [[ ! "$(type -P envoy)" ]]; then
    #     log_info "Installing Laravel Envoy"
    #     sudo curl https://github.com/laravel/envoy/raw/master/envoy.phar -o /usr/local/bin/envoy
    #     sudo chmod +x /usr/local/bin/envoy
    # fi

    # install php-cs-fixer
    # if [[ ! "$(type -P php-cs-fixer)" ]]; then
    #     log_info "Installing php-cs-fixer"
    #     sudo curl http://cs.sensiolabs.org/get/php-cs-fixer.phar -o /usr/local/bin/php-cs-fixer
    #     sudo chmod a+x /usr/local/bin/php-cs-fixer
    # fi

    # install gems
    if [[ ! "$(type -P gem)" ]]; then
        log_error "gem utility not installed"
        return ${E_FAILURE}
    fi

    log_info "Installing Gems"
    packages=(
    bluecloth
    bundler
    CoffeeTags
    execjs
    haste
    jekyll
    json_pure
    kramdown
    mailcatcher
    mysql2xxxx
    pre-commit
    puppet
    pygmentize
    pygments.rb
    redcarpet
    rdiscount
    rhc
    teamocil
    watch
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo gem install $package
        }
    done

    # install pip
    sudo easy_install pip
    
    # install python packages
    if [[ ! "$(type -P pip)" ]]; then
        log_error "pip not installed"
        return ${E_FAILURE}
    fi
    log_info "Installing Python packages"

    packages=(
    distribute
    gmusicapi
    robotframework
    robotframework-selenium2screenshots
    stellar
    supervisor
    )
    for package in "${packages[@]}"
    do
        hash $package 2>/dev/null || {
            log_info "installing $package"
            sudo pip install $package
        }
    done

    # install tmux plugin manager
    if [[ ! -f "$HOME/.tmux/plugins/tpm" ]]; then
        log_info "installing tmux plugin manager"
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi

    return ${E_SUCCESS}
}
