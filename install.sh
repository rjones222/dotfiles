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

# install gems
gem install pygmentize

# add ruby gems to path
export PATH=$(brew --prefix ruby)/bin:$PATH

# install ctags patched
# @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
cd /usr/local/Library/Formula
curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
brew install ctags --HEAD

# Symlink the configuration files into their appropriate homes if they don't already exist
[ -f ~/.gitconfig ] && ln -s ~/.dotfiles/gitconfig ~/.gitconfig
[ -f ~/.config ] && ln -s ~/.dotfiles/config ~/.config
[ -f ~/.gitignore ] && ln -s ~/.dotfiles/gitignore ~/.gitignore
[ -f ~/.profile ] && ln -s ~/.dotfiles/profile ~/.profile
[ -f ~/.screenrc ] && ln -s ~/.dotfiles/screenrc ~/.screenrc
[ -f ~/.tmux.conf ] && ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
[ -f ~/.grcat ] && ln -s ~/.dotfiles/grcat ~/.grcat
[ -f ~/.my.cnf ] && ln -s ~/.dotfiles/my.cnf ~/.my.cnf
[ -f ~/.my.ini ] && ln -s ~/.dotfiles/my.ini ~/.my.ini
[ -f ~/.inputrc ] && ln -s ~/.dotfiles/inputrc ~/.inputrc
[ -f ~/.rainbarf.conf ] && ln -s ~/.dotfiles/rainbarf.conf ~/.rainbarf.conf
[ -f ~/.vimrc.bundles.local ] && ln -s ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local
[ -f ~/.vimrc.local ] && ln -s ~/.dotfiles/vimrc.local ~/.vimrc.local
[ -f ~/.vimrc.before.local ] && ln -s ~/.dotfiles/vimrc.before.local ~/.vimrc.before.local
[ -f ~/.tmuxinator ] && ln -s ~/.dotfiles/tmuxinator ~/.tmuxinator
[ -f ~/.ctags ] && ln -s ~/.dotfiles/ctags ~/.ctags
[ -f /usr/local/php5/php.d/999-my-php.ini ] && ln -s ~/.dotfiles/999-my-php.ini /usr/local/php5/php.d/999-my-php.ini
[ -f /etc/apache2/other/999-my-httpd.conf ] && ln -s ~/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

# install vim packages
vim +BundleInstall +BundleClean! +qall
