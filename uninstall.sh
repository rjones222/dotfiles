#!/bin/bash

# pretty colors
GREEN=$(tput setaf 2)
RESET=$(tput setaf 0)

echo -e "${GREEN}uninstalling homebrew apps...${RESET}"
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
brew uninstall nodejs
brew uninstall virtualhost.sh
brew uninstall selenium-server-standalone
brew uninstall grc
brew uninstall ctags

echo -e "${GREEN}uninstalling executables...${RESET}"
rm /usr/local/bin/php-cs-fixer
rm /usr/local/bin/composer

echo -e "${GREEN}uninstalling gems...${RESET}"
gem uninstall pygmentize
gem uninstall observr
gem uninstall tmuxinator

# uninstall npm packages
echo -e "${GREEN}uninstalling npm packages...${RESET}"
# npm uninstall -g powerline-js

echo -e "${GREEN}removing symlinked configs...${RESET}"
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
# [ -L /usr/local/bin/powerline.js ] && rm /usr/local/bin/powerline.js
[ -L ~/.vim/UltiSnips ] && rm ~/.vim/UltiSnips
[ -L /usr/local/php5/php.d/999-my-php.ini ] && rm /usr/local/php5/php.d/999-my-php.ini
[ -L /etc/apache2/other/999-my-httpd.conf ] && sudo rm /etc/apache2/other/999-my-httpd.conf

echo -e "${GREEN}restoring paths...${RESET}"
if [ -f /etc/paths_BACKUP ];
then
    sudo rm /etc/paths
    sudo mv /etc/paths_BACKUP /etc/paths
fi

echo -e "${GREEN}uninstalling vim packages...${RESET}"
vim +BundleClean! +qall

echo -e "${GREEN}uninstall complete!${RESET}"
