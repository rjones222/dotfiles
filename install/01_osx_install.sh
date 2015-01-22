#!/usr/bin/env bash

# Modeline and Notes {{{
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
#
#  ___  ____ _         ______           _
#  |  \/  (_) |        |  ___|         | |
#  | .  . |_| | _____  | |_ _   _ _ __ | | __
#  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
#  | |  | | |   <  __/ | | | |_| | | | |   <
#  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
#
# link my dotfiles to their expected locations
# more info at http://mikefunk.com
# }}}

# source installer support files {{{
for f in ~/.dotfiles/install/support/*; do source $f; done
# }}}

log_info "Beginning mac install script"

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
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
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
        autossh # keeps ssh connections open for instant access
        bash # homebrew has the newest version of bash
        # ack # a search tool better than grep but worse than ag
        # cloc #count lines of code
        colortail # tail with support for colors
        ctags # allows jumping to function/class definitions, etc. in vim
        dnsmasq # easily set up dynamic dev domains such as myproject.dev
        # dos2unix # converts dos line endings to unix in a file
        # fasd # Command-line productivity booster, offers quick access to files and directories, inspired by autojump, z and v.
        git
        git-extras # adds some cool additional git commands
        git-flow # adds first class git commands for the git-flow workflow
        # googlecl # google command line tool
        # graphviz # useful for xdebug profiler class maps
        grc # generic colorizer
        gnu-sed # linux version of sed - saves as gsed
        # go # go programming language. used for mailhog.
        gpg # used by s3cmd
        # hg # mercurial
        highlight # colorizes html and other output on the command line
        htop # prettier, more powerful version of top. gets the top running processes
        hub # github tool is a superset of git
        # imagemagick # image transformation tool
        irssi # irc client
        # jsawk # parse json in bash
        # macvim # mac gui vim client
        # multitail # tail multiple files in splits with pretty colors
        mysql
        nodejs
        pandoc # used for inline vim php documentation
        # postgresql
        ranger # vim-like file system browser
        rbenv # ruby environment switcher
        reattach-to-user-namespace # used to fix mac issues with copy/paste in tmux
        ruby-build # an rbenv plugin that provides an rbenv install command to compile and install different versions of ruby
        s3cmd # amazon s3 uploader
        ssh-copy-id # copies ssh keys to remote servers
        # sshfs # mounts ssh servers as file systems in the local fs
        # sshuttle # poor mans vpn. doesnt work on yosemite at the moment
        # solr # search data server
        # spark # used for rainbarf to show spiffy cli graphs
        terminal-notifier # send macos notifications from terminal
        tig # git? tig!
        tmux # terminal multiplexer similar to screen
        tofrodos # line endings
        # trash # a trash can for the terminal
        tree # display file/folder hierarchies in a visual tree format
        # virtualhost.sh # crappy virtualhost management script
        # watch # contains some tools: free, kill, ps, uptime, etc.
        wget # latest version
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
            brew install macvim --with-lua --override-system-vim
        fi

        # https://github.com/neovim/neovim/wiki/Installing
        # bookmarking this for later. right now some things are still breaking
        # in my vim setup with neovim.
        # if [[ ! "$(type -P nvim)" ]]; then
            # brew tap neovim/homebrew-neovim
            # brew install --HEAD neovim
            # sudo pip install neovim
            # ln -sf ~/.vim ~/.nvim
            # ln -sf ~/.vimrc ~/.nvimrc
        # else
            # brew reinstall --HEAD neovim
        # fi

        log_info "setting up homebrew mysql to launch now and on startup"
        ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

        # ensuring homebrew bash is in /etc/shells
        if [[ $(grep "/usr/local/bin/bash" /etc/shells -c) == 0 ]]; then
            log_info "installing homebrew bash to /etc/paths"
            sudo bash -c "echo /usr/local/bin/bash >> /etc/shells"
        fi

        # htop-osx requires root privileges to correctly display all running processes.
        if [[ -f /usr/local/Cellar/htop-osx/0.8.2.3/bin/htop ]]; then
            log_info "setting permissions/ownership for htop"
            # You can either run the program via `sudo` or set the setuid bit:
            sudo chown root:wheel /usr/local/Cellar/htop-osx/0.8.2.3/bin/htop
            sudo chmod u+s /usr/local/Cellar/htop-osx/0.8.2.3/bin/htop
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

        # set up dnsmasq
        log_info "setting up dnsmasq"
        link_this "$HOME/.dotfiles/to_link/dnsmasq.conf" "/usr/local/etc/dnsmasq.conf"
        # launch dnsmasq on startup
        sudo cp -fv /usr/local/opt/dnsmasq/*.plist /Library/LaunchDaemons
        # load dnsmasq now
        sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.dnsmasq.plist
        # set up dns resolver dir if not already there
        [[ -d "/etc/resolver" ]] || sudo mkdir -p /etc/resolver
        # link the dns resolver file
        link_this "$HOME/.dotfiles/to_link/dev_dns_resolver" "/etc/resolver/dev"
        # restart dnsmasq
        sudo launchctl stop homebrew.mxcl.dnsmasq
        sudo launchctl start homebrew.mxcl.dnsmasq

        # install homebrew packages without the same cli name
        packages=(
        bash-completion # installs all homebrew bash completion
        selenium-server-standalone
        the_silver_searcher
        ruby-build
        )
        for package in "${packages[@]}"
        do
            log_info "attempting to install $package"
            brew install $package
        done

        # make selenium server start on launch
        ln -sfv /usr/local/opt/selenium-server-standalone/*.plist ~/Library/LaunchAgents
        launchctl load ~/Library/LaunchAgents/homebrew.mxcl.selenium-server-standalone.plist
    fi

    # install ctags patched
    # @link https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
    # log_info "Installing Ctags Patched"
    # cd /usr/local/Library/Formula/
    # curl https://raw.githubusercontent.com/shawncplus/phpcomplete.vim/master/misc/ctags-better-php.rb > /usr/local/Library/Formula/ctags-better-php.rb
    # brew install ctags-better-php
    # brew link --overwrite ctags-better-php

    # @link https://github.com/kopischke/homebrew-ctags
    log_info "Installing Ctags fishman"
    brew tap kopischke/ctags
    brew install ctags-fishman --HEAD

    # link brew apps
    brew linkapps

    # install php 5.5 via homebrew
    log_info "Installing homebrew php"
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php
    brew install php56 --with-homebrew-curl --with-libmysql --with-debug --withapache --with-imap --with-libxml
    brew install php56-xdebug php56-mcrypt
    # have launchd start php56 at login
    ln -sfv /usr/local/opt/php56/*.plist ~/Library/LaunchAgents
    # load php56 now
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.php56.plist
    # if extension not in httpd.conf, add it
    LoadPhp="LoadModule php5_module /usr/local/opt/php56/libexec/apache2/libphp5.so";
    echo $LoadPhp
    if ! grep -Fxq $LoadPhp; then
        log_info "adding php5 module to apache2 httpd.conf"
        sudo echo $LoadPhp >> /etc/apache2/httpd.conf
    fi

    # install phing bash completion
    log_info "installing bash completion for phing"
    if [[ ! -f /usr/local/etc/bash_completion.d/phing ]]; then
        log_info "Installing phing bash completion"
        cd
        wget https://gist.githubusercontent.com/krymen/4124392/raw/37c8436ac44cdd21620e3a355fc96cf6b7bf61a3/phing
        sudo mv phing /usr/local/etc/bash_completion.d/
    fi

    # download and move mailcatcher
    if [[ ! "$(type -P mailhog)" ]]; then
        log_info "installing mailhog"
        wget https://github.com/mailhog/MailHog/releases/download/v0.1.3/MailHog_darwin_amd64
        mv MailHog_darwin_amd64 /usr/local/bin/mailhog
        chmod +x /usr/local/bin/mailhog
    fi

else
    log_notice "This is not OSX so not running osx tasks"
fi

log_info "End mac install script"
