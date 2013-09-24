#!/bin/bash

# uninstall homebrew stuff
brew uninstall ack
brew uninstall bash-completion
brew uninstall git
brew uninstall graphviz
brew uninstall highlight
brew uninstall hub
brew uninstall imagemagick
brew uninstall macvim
brew uninstall mysql
brew uninstall qcachegrind
brew uninstall reattach-to-user-namespace
brew uninstall ruby
brew uninstall the_silver_searcher
brew uninstall tmux
brew uninstall tree
brew uninstall wget

# uninstall cli stuff
rm /usr/local/bin/php-cs-fixer

# uninstall gems
gem uninstall pygmentize

# uninstall ctags patched
brew uninstall ctags

# remove symlinked configs
[ -L ~/.gitconfig ] && rm ~/.gitconfig
[ -L ~/.config ] && rm ~/.config
[ -L ~/.ssh/config ] && rm ~/.ssh/config
[ -L ~/.gitignore ] && rm ~/.gitignore
[ -L ~/.profile ] && rm ~/.profile
[ -L ~/.screenrc ] && rm ~/.screenrc
[ -L ~/.tmux.conf ] && rm ~/.tmux.conf
[ -L ~/.grcat ] && rm ~/.grcat
[ -L ~/.my.cnf ] && rm ~/.my.cnf
[ -L ~/.my.ini ] && rm ~/.my.ini
[ -L ~/.inputrc ] && rm ~/.inputrc
[ -L ~/.rainbarf.conf ] && rm ~/.rainbarf.conf
[ -L ~/.vimrc.bundles.local ] && rm ~/.vimrc.bundles.local
[ -L ~/.vimrc.local ] && rm ~/.vimrc.local
[ -L ~/.vimrc.before.local ] && rm ~/.vimrc.before.local
[ -L ~/.tmuxinator ] && rm ~/.tmuxinator
[ -L ~/.ctags ] && rm ~/.ctags
[ -L /usr/local/php5/php.d/999-my-php.ini ] && rm /usr/local/php5/php.d/999-my-php.ini
[ -L /etc/apache2/other/999-my-httpd.conf ] && sudo rm /etc/apache2/other/999-my-httpd.conf

# uninstall vim packages
# vim +BundleClean! +qall
