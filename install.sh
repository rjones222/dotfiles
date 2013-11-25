#!/bin/bash

# Logging stuff.
function e_header()   { echo -e "\n\033[1m$@\033[0m"; }
function e_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function e_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }

# Given a list of desired items and installed items, return a list
# of uninstalled items. Arrays in bash are insane (not in a good way).
function to_install() {
  local debug desired installed i desired_s installed_s remain
  if [[ "$1" == 1 ]]; then debug=1; shift; fi

  # Convert args to arrays, handling both space- and newline-separated lists.
  read -ra desired < <(echo "$1" | tr '\n' ' ')
  read -ra installed < <(echo "$2" | tr '\n' ' ')

  # Sort desired and installed arrays.
  unset i; while read -r; do desired_s[i++]=$REPLY; done < <(
    printf "%s\n" "${desired[@]}" | sort
  )
  unset i; while read -r; do installed_s[i++]=$REPLY; done < <(
    printf "%s\n" "${installed[@]}" | sort
  )
  # Get the difference. comm is awesome.
  unset i; while read -r; do remain[i++]=$REPLY; done < <(
    comm -13 <(printf "%s\n" "${installed_s[@]}") <(printf "%s\n" "${desired_s[@]}")
  )
  [[ "$debug" ]] && for v in desired desired_s installed installed_s remain; do
    echo "$v ($(eval echo "\${#$v[*]}")) $(eval echo "\${$v[*]}")"
  done
  echo "${remain[@]}"
}

# Ensure that we can actually, like, compile anything.
if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
  e_error "XCode or the Command Line Tools for XCode must be installed first."
  exit 1
fi

# If Git is not installed, install it (Ubuntu only, since Git comes standard
# with recent XCode or CLT)
if [[ ! "$(type -P git)" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
  e_header "Installing Git"
  sudo apt-get -qq install git-core
fi

# If Git isn't installed by now, something exploded. We gots to quit!
if [[ ! "$(type -P git)" ]]; then
  e_error "Git should be installed. It isn't. Aborting."
  exit 1
fi

# Download or update.
if [[ ! -d ~/.dotfiles ]]; then
  new_dotfiles_install=1

  # ~/.dotfiles doesn't exist? Clone it!
  e_header "Downloading dotfiles"
  cd
  git clone --recursive https://github.com/mikedfunk/dotfiles.git ~/.dotfiles
  cd ~/.dotfiles
else

  # Make sure we have the latest files.
  e_header "Updating dotfiles"
  cd ~/.dotfiles
  git pull
  git submodule update --init --recursive --quiet
fi

# -------------------------------
# OSX-only stuff. Abort if not OSX.
if [[ "$OSTYPE" =~ ^darwin ]]; then

    # set mac preferences
    e_header "Setting Mac preferences"
    defaults write com.apple.finder NewWindowTargetPath file://Users/mfunk/
    defaults write com.apple.finder AppleShowAllFiles TRUE
    killall Finder

    # Install Homebrew.
    if [[ ! "$(type -P brew)" ]]; then
        e_header "Installing Homebrew"
        true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    fi

    if [[ "$(type -P brew)" ]]; then
        e_header "Updating Homebrew"
        brew doctor
        brew update
        brew tap phinze/homebrew-cask

        # Install Homebrew recipes.
        recipes=(
            ack
            bash-completion
            brew-cask
            ctags
            git
            git-extras
            # graphviz
            grc
            highlight
            htop-osx
            hub
            imagemagick
            irssi
            # lesspipe nmap
            macvim
            mysql
            nodejs
            # qcachegrind
            reattach-to-user-namespace
            rbenv
            selenium-server-standalone
            ssh-copy-id
            terminal-notifier
            the_silver_searcher
            tmux
            tree
            vagrant
            wget
        )

        list="$(to_install "${recipes[*]}" "$(brew list)")"
        if [[ "$list" ]]; then
            e_header "Installing Homebrew recipes: $list"
            brew install $list
        fi

        # Install brew casks
        casks=(
            cyberduck
            dropbox
            google-chrome
            google-drive
            google-music-manager
            iterm2
            sequel-pro
            virtualbox
        )

        list="$(to_install "${casks[*]}" "$(brew cask list)")"
        if [[ "$list" ]]; then
            e_header "Installing Homebrew casks: $list"
            brew cask install $list
        fi
    fi

    # install ctags patched
    # @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
    if [[ ! -f /usr/local/etc/.ctags_patched_installed ]]; then
        e_header "installing ctags patched"
        cd /usr/local/Library/Formula
        curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
        brew install ctags --HEAD
        touch /usr/local/etc/.ctags_patched_installed
    fi

fi

# end mac only
# ------------------------

# Linux only
if [[ ! "$(type -P apt-get)" ]]; then

    # install linux packages
    sudo apt-get install ack
    sudo apt-get install ctags
    sudo apt-get install git-extras
    sudo apt-get install highlight
    sudo apt-get install htop
    sudo apt-get install irssi
    sudo apt-get install rake
    sudo apt-get install rbenv
    sudo apt-get install silversearcher-ag
    sudo apt-get install tmux
    sudo apt-get install tree
    sudo apt-get install vagrant
    sudo apt-get install vim
    # sudo apt-get install vim-nox

    # install github's hub
    git clone git://github.com/github/hub.git
    cd hub
    rake install
fi

# end linux only
# ------------------------

# install php-cs-fixer
if [[ ! -f /usr/local/bin/php-cs-fixer ]]; then
    e_header "installing cli tools"
    sudo wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
    sudo chmod a+x /usr/local/bin/php-cs-fixer
fi

# install composer
if [[ ! "$(type -P composer)" ]]; then
  e_header "installing composer"
    curl -sS https://getcomposer.org/installer | php
    sudo mv composer.phar /usr/local/bin/composer
    sudo chmod +x composer
    cd
fi

# install node packages
# npm install -g powerline-js

# install gems
e_header "installing gems"
sudo gem install pygmentize
sudo gem install observr
sudo gem install tmuxinator

# install phpctags
if [[ ! -d ~/.dotfiles/phpctags/build ]]; then
    e_header "installing phpctags"
    cd ~/.dotfiles/phpctags
    make
    ln -s ~/.dotfiles/phpctags/phpctags /usr/local/bin/phpctags
    cd -
fi

function link_this() {

    # set better vars for source and dest

    # if the symlink exists, skip it and notify
    if [[ "$1" -ef "$2" ]]; then
        e_error "symlink $2 exists"
        return

    # if the file already exists
    if [ -e $2 ]; then

        # create a backup dir if it doesn't already exist and notify
        backup_dir = "$HOME/backup/"
        [[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"

        # move the file to the backup dir and notify
        e_success "backing up $2"
        mv $2 $backup_dir
    else
        e_success "files dont exist $2"
    fi


    # else symlink it and notify
    else
        e_success "linking $1 to $2"
        ln -s $1 $2
    fi
}
# Symlink the configuration files into their appropriate homes if they don't already exist
e_header "installing symlinks"
cd ~/.dotfiles
link_this "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
link_this "$HOME/.dotfiles/gitignore" "$HOME/.gitignore"
link_this "$HOME/.dotfiles/config" "$HOME/.config"
link_this "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
link_this "$HOME/.dotfiles/ctags" "$HOME/.ctags"
link_this "$HOME/.dotfiles/profile" "$HOME/.profile"
link_this "$HOME/.dotfiles/screenrc" "$HOME/.screenrc"
link_this "$HOME/.dotfiles/tmux.conf" "$HOME/.tmux.conf"
link_this "$HOME/.dotfiles/grcat" "$HOME/.grcat"
link_this "$HOME/.dotfiles/my.cnf" "$HOME/.my.cnf"
link_this "$HOME/.dotfiles/my.ini" "$HOME/.my.ini"
link_this "$HOME/.dotfiles/inputrc" "$HOME/.inputrc"
link_this "$HOME/.dotfiles/rainbarf.conf" "$HOME/.rainbarf.conf"
link_this "$HOME/.dotfiles/vimrc.bundles.local" "$HOME/.vimrc.bundles.local"
link_this "$HOME/.dotfiles/vimrc.local" "$HOME/.vimrc.local"
link_this "$HOME/.dotfiles/vimrc.before.local" "$HOME/.vimrc.before.local"
link_this "$HOME/.dotfiles/tmuxinator" "$HOME/.tmuxinator"
link_this "$HOME/.dotfiles/tmuxinator" "$HOME/.tmuxinator"
# link_this "$HOME/.dotfiles/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
# sudo ln -s $HOME/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

# install spf13
e_header "installing spf13"
curl http://j.mp/spf13-vim3 -L -o - | sh
vim +BundleClean! +qall!

# this needs to be after the .vim folder is created
link_this "$HOME/.dotfiles/UltiSnips" "$HOME/.vim/UltiSnips"

e_success "installation complete!"
