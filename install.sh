#!/bin/bash

# install homebrew stuff
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
brew install ack
brew install bash-completion
brew install git
brew install graphviz
brew install highlight
brew install hub
brew install imagemagick
brew install macvim
brew install mysql
brew install qcachegrind
brew install reattach-to-user-namespace
brew install ruby
brew install the_silver_searcher
brew install tmux
brew install tree
brew install wget

# install cli stuff
sudo wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
sudo chmod a+x /usr/local/bin/php-cs-fixer
# install ctags patched

# Symlink the configuration files into their appropriate homes
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/config ~/.config
ln -s ~/.dotfiles/gitignore ~/.gitignore
ln -s ~/.dotfiles/profile ~/.profile
ln -s ~/.dotfiles/screenrc ~/.screenrc
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/grcat ~/.grcat
ln -s ~/.dotfiles/my.cnf ~/.my.cnf
ln -s ~/.dotfiles/my.ini ~/.my.ini
ln -s ~/.dotfiles/inputrc ~/.inputrc
ln -s ~/.dotfiles/rainbarf.conf ~/.rainbarf.conf
ln -s ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local
ln -s ~/.dotfiles/vimrc.local ~/.vimrc.local
ln -s ~/.dotfiles/vimrc.before ~/.vimrc.before
ln -s ~/.dotfiles/tmuxinator ~/.tmuxinator
ln -s ~/.dotfiles/ctags ~/.ctags
ln -s ~/.dotfiles/999-my-php.ini /usr/local/php5/php.d/999-my-php.ini
ln -s ~/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

# install vim packages
vim +BundleInstall +qall
