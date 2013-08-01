#!/bin/bash

# Symlink the configuration files into their appropriate homes
ln -s ~/.dotfiles/gitconfig ~/.gitconfig
ln -s ~/.dotfiles/config ~/.config
ln -s ~/.dotfiles/gitignore ~/.gitignore
ln -s ~/.dotfiles/profile ~/.profile
ln -s ~/.dotfiles/screenrc ~/.screenrc
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/grcat ~/.grcat
ln -s ~/.dotfiles/my.cnf ~/.my.cnf
ln -s ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local
ln -s ~/.dotfiles/vimrc.local ~/.vimrc.local
ln -s ~/.dotfiles/tmuxinator ~/.tmuxinator
ln -s ~/.dotfiles/999-my-php.ini /usr/local/php5/php.d/999-my-php.ini
ln -s ~/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

# install vim packages
vim +BundleInstall +qall
