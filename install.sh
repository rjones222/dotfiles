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
			# cowsay
			ctags
			git
			git-extras
			# graphviz
			grc
			highlight
			htop-osx
			man2html
			hub
			id3tool
			imagemagick
			lesspipe nmap
			macvim
			mysql
			nodejs
			qcachegrind
			reattach-to-user-namespace
			rbenv
			selenium-server-standalone
			sl
			ssh-copy-id
			the_silver_searcher
			tmux
			tree
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

# end mac only
# ------------------------

e_header "installing cli tools"
# install php-cs-fixer
if [[ ! -f /usr/local/bin/php-cs-fixer ]]; then
	sudo wget http://cs.sensiolabs.org/get/php-cs-fixer.phar -O /usr/local/bin/php-cs-fixer
	sudo chmod a+x /usr/local/bin/php-cs-fixer
fi

# install composer
if [[ ! -f /usr/local/bin/composer ]]; then
  e_header "installing composer"
	cd /usr/local/bin
	curl -sS https://getcomposer.org/installer | php
	mv composer.phar composer
	sudo chmod +x composer
	cd
fi

# install node packages
# npm install -g powerline-js

# install gems
e_header "installing gems"
gem install pygmentize
gem install observr
gem install tmuxinator

# install ctags patched
# @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
if [[ ! -f /usr/local/etc/.ctags_patched_installed ]]; then
	e_header "installing ctags patched"
	cd /usr/local/Library/Formula
	curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
	brew install ctags --HEAD
	touch /usr/local/etc/.ctags_patched_installed
fi

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
	local dstfile srcfile
	srcfile = $1
	dstfile = $2

	# if the file already exists
	if [[ -e "$dstfile" ]]; then

		# create a backup dir if it doesn't already exist and notify
		backup_dir = "$HOME/backup/"
		[[ -e "$backup_dir" ]] || mkdir -p "$backup_dir"

		# move the file to the backup dir and notify
		e_success "backing up $dstfile"
		mv $dstfile $backup_dir
	fi

	# if the symlink exists, skip it and notify
	if [[ "$srcfile" -ef "$dstfile" ]]; then
		e_error "symlink $dstfile exists"
		return

	# else symlink it and notify
	else
		e_success "linking $srcfile to $dstfile"
		ln -s $srcfile $dstfile
	fi
}
# Symlink the configuration files into their appropriate homes if they don't already exist
e_header "installing symlinks"
link_this "~/.dotfiles/gitconfig" "~/.gitconfig"
link_this "~/.dotfiles/config" "~/.config"
link_this "~/.dotfiles/ssh/config" "~/.ssh/config"
link_this "~/.dotfiles/gitignore" "~/.gitignore"
link_this "~/.dotfiles/profile" "~/.profile"
link_this "~/.dotfiles/screenrc" "~/.screenrc"
link_this "~/.dotfiles/tmux.conf" "~/.tmux.conf"
link_this "~/.dotfiles/grcat" "~/.grcat"
link_this "~/.dotfiles/my.cnf" "~/.my.cnf"
link_this "~/.dotfiles/my.ini" "~/.my.ini"
link_this "~/.dotfiles/inputrc" "~/.inputrc"
link_this "~/.dotfiles/rainbarf.conf" "~/.rainbarf.conf"
link_this "~/.dotfiles/vimrc.bundles.local" "~/.vimrc.bundles.local"
link_this "~/.dotfiles/vimrc.local" "~/.vimrc.local"
link_this "~/.dotfiles/vimrc.before.local" "~/.vimrc.before.local"
link_this "~/.dotfiles/tmuxinator" "~/.tmuxinator"
link_this "~/.dotfiles/ctags" "~/.ctags"
link_this "~/.dotfiles/UltiSnips" "~/.vim/UltiSnips"
link_this "~/.dotfiles/selenium-server.jar" "/usr/local/bin/selenium-server.jar"
link_this "~/.dotfiles/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
# sudo ln -s ~/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

if [[ ! -d $HOME/.spf13-vim-3 ]]; then
  # install spf13
  e_header "installing spf13"
  curl http://j.mp/spf13-vim3 -L -o - | sh
  e_header "removing unused vim plugins"
  vim +BundleClean! +qall

  # build some vim packages
  # e_header "installing youcompleteme"
  # cd ~/.vim/bundle/YouCompleteMe
  # ./install.sh --clang-completer
  # cd ~/.vim/bundle/vimproc.vim
  # make
  # cd -
fi

if grep -q "^/usr/local/bin" /etc/paths
then
  # prepend to /etc/paths
  e_header "prepending to paths"
  sudo cp /etc/paths /etc/paths_BACKUP
  echo -e "/usr/local/bin"|cat - /etc/paths > /tmp/out 
  sudo mv /tmp/out /etc/paths
fi

e_success "install complete!"
fi
