#!/usr/bin/env bash
log_info "Beginning common install script"

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
fixmyjs
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
phpunit-watchr
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
# observr
pre-commit
# pre-commit-php
puppet
pygmentize
pygments.rb
redcarpet
rdiscount
rhc
# ruby-fsevent
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
# gmusicapi
argcomplete
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

log_info "activating argcomplete"
activate-global-python-argcomplete

# install tmux plugin manager
if [[ ! -f "$HOME/.tmux/plugins/tpm" ]]; then
    log_info "installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

log_info "End common install script"
