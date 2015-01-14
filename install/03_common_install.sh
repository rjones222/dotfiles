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

log_info "Beginning common install script"

# install npm packages
if [[ ! "$(type -P npm)" ]]; then
    log_error "npm not installed"
    return ${E_FAILURE}
fi

log_info "Installing npm Packages"
packages=(
bower # package management for css/js
bower-installer # allows you to only install the files you need into a specific dir
browser-sync # like livereload but easier
coffeelint # verify coffeescript files
coffee-script # javascript abstraction / augmentation
csslint # verify css files
# fixmyjs # like php-cs-fixer for javascript
git-guilt # see the top few users for whom this commit has overwritten code
gulp # task runner / watcher
# grunt # older, more complex task runner / watcher
instant-markdown-d # used by vim to instantly preview markdown files as you type
jshint # like jslint but less punishing
# json # json formatter used for vim
jsonlint # verify json
karma-cli # karma testing framework command line runner
less # add dynamic capabilities to less
letswork # distraction remover (no reddit, facebook, twitter)
# localtunnel # allow others to view a site you have running locally
# log.io # web-based live log browser
npm-check-updates # check for updates to stuff defined in package.json
# phantomjs # headless browser used for BDD
# phpunit-watchr # dinky tool to watch files for changes and run phpunit
# tldr # community-driven man pages
yo # yeoman - boilerplate maker
# zombie # browser emulator for testing like phantomjs
)
for package in "${packages[@]}"
do
    hash $package 2>/dev/null || {
        log_info "installing $package"
        sudo npm install -g $package --user "$(whoami)"
    }
done

# jsctags
if [[ ! "$(type -P jsctags)" ]]; then
    log_info "Installing jsctags"
    sudo npm install -g git://github.com/ramitos/jsctags.git
fi

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

# had some problems with php-cs-fixer via composer so here's the wget version
if [[ ! "$(type -P php-cs-fixer)" ]]; then
    log_info "Installing php-cs-fixer"
    sudo wget http://get.sensiolabs.org/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
    sudo chmod +x /usr/local/bin/php-cs-fixer
fi

# build phpctags
if [[ ! "$(type -P phpctags)" ]]; then
    log_info "building phpctags"
    cd $HOME/.composer/vendor/techlivezheng/phpctags
    make
    cp build/phpctags.phar $HOME/.composer/vendor/bin/phpctags
    sudo chmod +x $HOME/.composer/vendor/bin/phpctags
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

# install gems
if [[ ! "$(type -P gem)" ]]; then
    log_error "gem utility not installed"
    return ${E_FAILURE}
fi

log_info "Installing Gems"
packages=(
# bluecloth # ruby implementation of markdown. Another option jekyll can use.
# bropages # a highly readable supplement to man pages
bundler # lets gems be package-specific. Used by jekyll.
CoffeeTags # ctags with coffeescript
# execjs
# git-gitlab # command line tool to create merge requests and stuff
# haste
jekyll # blogging platform used by github
# json_pure
# kramdown # another markdown parser option that can be used by Jekyll.
# mailcatcher # catches outgoing mail and displays it from a local server to a web-based view
# mysql2xxxx # export mysql to json, etc.
# observr # watches the file system and does stuff when things change
pre-commit # install pre-commit hooks to check for all kinds of things
# pre-commit-php
# puppet # virtual machine provisioning language
pygmentize # used by jekyll
pygments.rb # syntax highlighting - used by jekyll
redcarpet # used by jekyll to convert markdown to html
# rdiscount # another markdown option for jekyll.
# ruby-fsevent # probably a dependency of another package I dont use anymore
teamocil # save tmux layouts and regenerate them with ease
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
# gmusicapi # google music api
# argcomplete # tab completion of arguments for python scripts
# pgcli # a postgresql repl with autocompletion
requests # used for vim-jira-complete
# robotframework # front-end testing framework
# robotframework-selenium2screenshots
# stellar # fast database stapshot and restore tool for development
# supervisor # a client/server system that allows its users to control a number of processes
)
for package in "${packages[@]}"
do
    hash $package 2>/dev/null || {
        log_info "installing $package"
        sudo pip install $package
    }
done

# disabled - it uses a -D switch on mac which doesn't exist
# log_info "activating argcomplete"
# depends on location of bash completion folder
# [ -d /usr/local/etc/bash_completion.d ] && activate-global-python-argcomplete --dest /usr/local/etc/bash_completion.d
# [ -d /etc/bash_completion.d ] && activate-global-python-argcomplete --dest /etc/bash_completion.d

# install tmux plugin manager
if [[ ! -f "$HOME/.tmux/plugins/tpm" ]]; then
    log_info "installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [[ "$(type -P vagrant)" ]]; then
    log_info "adding laravel homestead vagrant box"
    vagrant box add laravel/homestead
    # homestead cli tool is in global composer.json
fi

log_info "End common install script"
