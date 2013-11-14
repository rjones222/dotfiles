#!/bin/bash

# pretty colors
GREEN=$(tput setaf 2)
RESET=$(tput setaf 0)

# clone dotfiles with submodules
echo -e "${GREEN}cloning dotfiles into home directory...${RESET}"
cd ~
git clone git@github.com:mikedfunk/dotfiles.git .dotfiles --recursive

# install spf13
echo -e "${GREEN}installing spf13...${RESET}"
curl http://j.mp/spf13-vim3 -L -o - | sh

# finder show hidden stuff
if [ -f ~/Library/Preferences/com.apple.finder.plist ];
then
    defaults write com.apple.Finder AppleShowAllFiles TRUE
    killall Finder
fi

# install homebrew stuff
echo -e "${GREEN}installing homebrew...${RESET}"
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
brew install nodejs
brew install virtualhost.sh
brew install selenium-server-standalone
brew install grc
brew linkapps

echo -e "${GREEN}installing cli tools...${RESET}"
# install php-cs-fixer
sudo wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
sudo chmod a+x /usr/local/bin/php-cs-fixer

# install composer
cd /usr/local/bin
curl -sS https://getcomposer.org/installer | php
mv composer.phar composer
sudo chmod +x composer

# install node packages
# npm install -g powerline-js

# install gems
echo -e "${GREEN}installing gems...${RESET}"
gem install pygmentize
gem install observr
gem install tmuxinator

# install ctags patched
# @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
echo -e "${GREEN}installing ctags patched...${RESET}"
cd /usr/local/Library/Formula
curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
brew install ctags --HEAD

# install phpctags
cd ~/.dotfiles/phpctags
make
ln -s ~/.dotfiles/phpctags/phpctags /usr/local/bin/phpctags
cd -

# Symlink the configuration files into their appropriate homes if they don't already exist
echo -e "${GREEN}installing symlinks...${RESET}"
[ ! -f ~/.gitconfig ] && ln -s ~/.dotfiles/gitconfig ~/.gitconfig
[ ! -f ~/.config ] && ln -s ~/.dotfiles/config ~/.config
[ ! -f ~/.ssh/config ] && ln -s ~/.dotfiles/ssh/config ~/.ssh/config
[ ! -f ~/.gitignore ] && ln -s ~/.dotfiles/gitignore ~/.gitignore
[ ! -f ~/.profile ] && ln -s ~/.dotfiles/profile ~/.profile
[ ! -f ~/.screenrc ] && ln -s ~/.dotfiles/screenrc ~/.screenrc
[ ! -f ~/.tmux.conf ] && ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
[ ! -f ~/.grcat ] && ln -s ~/.dotfiles/grcat ~/.grcat
[ ! -f ~/.my.cnf ] && ln -s ~/.dotfiles/my.cnf ~/.my.cnf
[ ! -f ~/.my.ini ] && ln -s ~/.dotfiles/my.ini ~/.my.ini
[ ! -f ~/.inputrc ] && ln -s ~/.dotfiles/inputrc ~/.inputrc
[ ! -f ~/.rainbarf.conf ] && ln -s ~/.dotfiles/rainbarf.conf ~/.rainbarf.conf
[ ! -f ~/.vimrc.bundles.local ] && ln -s ~/.dotfiles/vimrc.bundles.local ~/.vimrc.bundles.local
[ ! -f ~/.vimrc.local ] && ln -s ~/.dotfiles/vimrc.local ~/.vimrc.local
[ ! -f ~/.vimrc.before.local ] && ln -s ~/.dotfiles/vimrc.before.local ~/.vimrc.before.local
[ ! -f ~/.tmuxinator ] && ln -s ~/.dotfiles/tmuxinator ~/.tmuxinator
[ ! -f ~/.ctags ] && ln -s ~/.dotfiles/ctags ~/.ctags
# [ ! -f /usr/local/bin/powerline.js ] && ln -s /usr/local/lib/node_modules/powerline/powerline.js /usr/local/bin/powerline.js
[ ! -f ~/.vim/UltiSnips ] && ln -s ~/.dotfiles/UltiSnips ~/.vim/UltiSnips
[ ! -f /usr/local/bin/selenium-server.jar ] && ln -s ~/.dotfiles/selenium-server.jar /usr/local/bin/selenium-server.jar
[ ! -f /usr/local/php5/php.d/999-my-php.ini ] && ln -s ~/.dotfiles/999-my-php.ini /usr/local/php5/php.d/999-my-php.ini
[ ! -f /etc/apache2/other/999-my-httpd.conf ] && sudo ln -s ~/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

# install vim packages
echo -e "${GREEN}installing vim packages...${RESET}"
curl http://j.mp/spf13-vim3 -L -o - | sh #install spf-13-vim
vim +BundleClean! +qall

# build some vim packages
echo -e "${GREEN}installing youcompleteme...${RESET}"
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
cd ~/.vim/bundle/vimproc.vim
make
cd -

# prepend to /etc/paths
echo -e "${GREEN}prepending to paths...${RESET}"
sudo cp /etc/paths /etc/paths_BACKUP
echo -e "/usr/local/bin"|cat - /etc/paths > /tmp/out 
sudo mv /tmp/out /etc/paths

echo -e "${GREEN}install complete!${RESET}"
