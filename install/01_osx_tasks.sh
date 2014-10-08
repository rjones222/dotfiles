#!/usr/bin/env bash

# OSX-only stuff. Abort if not OSX.
if [[ "$OSTYPE" =~ ^darwin ]]; then

    # set mac preferences
    if [[ $(defaults read com.apple.finder NewWindowTargetPath) != "file://Users/mfunk" ]]; then
        log_info "setting finder default location"
        defaults write com.apple.finder NewWindowTargetPath file://Users/mfunk/
    fi

    if [[ $(defaults read com.apple.finder AppleShowAllFiles) != "TRUE" ]]; then
        log_info "setting finder to show hidden files"
        defaults write com.apple.finder AppleShowAllFiles TRUE
        killall Finder
    fi

    # Install Homebrew.
    if [[ ! "$(type -P brew)" ]]; then
        log_info "Installing Homebrew"
        true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    fi

    if [[ "$(type -P brew)" ]]; then
        # update homebrew
        log_info "Updating Homebrew"
        brew doctor
        brew update
        # brew tap phinze/homebrew-cask

        # install homebrew recipes
        log_info "Installing Homebrew Recipes"
        packages=(
        autossh
        bash
        # ack
        cloc
        ctags
        # curl-ca-bundle
        # fasd
        git
        git-extras
        git-flow
        # googlecl
        graphviz
        grc
        # hg
        highlight
        htop
        hub
        imagemagick
        irssi
        # macvim
        multitail
        mysql
        nodejs
        pandoc
        # postgresql
        ranger
        rbenv
        reattach-to-user-namespace
        ruby-build
        ssh-copy-id
        sshfs
        sshuttle
        # solr
        spark
        terminal-notifier
        tig
        tmux
        tofrodos
        # trash
        tree
        # virtualhost.sh
        watch
        wget
        )
        for package in "${packages[@]}"
        do
            hash $package 2>/dev/null || {
                log_info "installing $package"
                brew install $package
            }
        done

        if [[ ! "$(type -P mvim)" ]]; then
            log_info "installing macvim"
            brew install macvim --with-lua --with-cscope --override-system-vim
        fi

        log_info "setting up homebrew mysql to launch now and on startup"
        ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

        # ensuring homebrew bash is in /etc/shells
        if [[ $(grep "/usr/local/bin/bash" /etc/shells -c) == 0 ]]; then
            log_info "installing bash to /etc/paths"
            sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
        fi

        if [[ ! "$(type -P libxml2)" ]]; then
            log_info "installing libxml2 with python (for phpqa vim package)"
            brew install libxml2 --with-python
            mkdir -p ~/Library/Python/2.7/lib/python/site-packages
            echo '/usr/local/opt/libxml2/lib/python2.7/site-packages' > ~/Library/Python/2.7/lib/python/site-packages/homebrew.pth
        fi

        if [[ ! "$(type -P battery)" ]]; then
            log_info "installing battery script for tmux statusline"
            brew tap Goles/battery
            brew install battery
        fi

        # install homebrew packages without the same cli name
        packages=(
        bash-completion
        selenium-server-standalone
        the_silver_searcher
        ruby-build
        )
        for package in "${packages[@]}"
        do
            log_info "attempting to install $package"
            brew install $package
        done
    fi

    # install ctags patched
    # @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
    log_info "Installing Ctags Patched"
    cd /usr/local/Library/Formula/
    curl https://raw.githubusercontent.com/shawncplus/phpcomplete.vim/master/misc/ctags-better-php.rb > /usr/local/Library/Formula/ctags-better-php.rb
    brew install ctags-better-php
    brew link --overwrite ctags-better-php

    # link brew apps
    brew linkapps

    # install php 5.5 via homebrew
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php
    brew install php56

    # install phing bash completion
    log_info "installing bash completion for phing"
    if [[ ! -f /usr/local/etc/bash_completion.d/phing ]]; then
        log_info "Installing phing bash completion"
        cd
        wget https://gist.githubusercontent.com/krymen/4124392/raw/37c8436ac44cdd21620e3a355fc96cf6b7bf61a3/phing
        sudo mv phing /usr/local/etc/bash_completion.d/
    fi

else
    log_error "This is not OSX so not running osx tasks"
fi
