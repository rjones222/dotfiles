#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function osx_tasks_init() {
    task_setup "osx_tasks" "OSX Tasks" "Execute tasks only if on Mac OSX"
}

function osx_tasks_run() {
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
            log_info "Updating Homebrew"
            brew doctor
            brew update
            # brew tap phinze/homebrew-cask

            log_info "Installing Homebrew Recipes"
            packages=(
            bash
            # ack
            ctags
            curl-ca-bundle
            # fasd
            git
            git-extras
            git-flow
            grc
            # hg
            highlight
            hub
            imagemagick
            irssi
            macvim
            multitail
            mysql
            nodejs
            # postgresql
            ranger
            reattach-to-user-namespace
            ssh-copy-id
            # solr
            terminal-notifier
            tmux
            trash
            tree
            wget
            )
            for package in "${packages[@]}"
            do
                hash $package 2>/dev/null || {
                    log_info "installing $package"
                    brew install $package
                }
            done

            if [[ $(grep "/usr/local/bin/bash" /etc/shells -c) == 0 ]]; then
                log_info "installing bash to /etc/paths"
                sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
            fi

            if [[ ! "$(type -P openssl-osx-ca)" ]]; then
                log_info "installing openssl-osx-ca to sync certificates"
                brew tap raggi/ale
                brew install openssl-osx-ca
                openssl-osx-ca
            fi

            # install packages without the same cli name
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

        # install ngrok
        if [[ ! "$(type -P ngrok)" ]]; then
            log_info "Installing ngrok"
            cd
            wget https://dl.ngrok.com/darwin_amd64/ngrok.zip
            unzip ngrok.zip
            sudo mv ngrok /usr/local/bin/ngrok
            sudo chmod +x /usr/local/bin/ngrok
            sudo rm ngrok.zip
        fi

        # install ctags patched
        # @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
        if [[ ! -f /usr/local/etc/.ctags_patched_installed ]]; then
            log_info "Installing Ctags Patched"
            cd /usr/local/Library/Formula
            curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
            brew install ctags --HEAD
            sudo touch /usr/local/etc/.ctags_patched_installed
        fi

        # install pip
        sudo easy_install pip

    else
        log_error "This is not OSX so not running osx tasks"
    fi

    return ${E_SUCCESS}
}
