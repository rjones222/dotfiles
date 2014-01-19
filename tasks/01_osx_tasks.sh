#!/usr/bin/env bash

function osx_tasks_init() {
	task_setup "osx_tasks" "OSX Tasks" "Execute tasks only if on Mac OSX" "setup"
}

function osx_tasks_run() {
	# OSX-only stuff. Abort if not OSX.
	if [[ "$OSTYPE" =~ ^darwin ]]; then

		# set mac preferences
		log_info "Setting Mac Preferences"
		defaults write com.apple.finder NewWindowTargetPath file://Users/mfunk/
		defaults write com.apple.finder AppleShowAllFiles TRUE
		killall Finder

		# Install Homebrew.
		if [[ ! "$(type -P brew)" ]]; then
			log_info "Installing Homebrew"
			true | ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
		fi

		if [[ "$(type -P brew)" ]]; then
			log_info "Updating Homebrew"
			brew doctor
			brew update
			# brew tap phinze/homebrew-cask

			log_info "Installing Homebrew Recipes"
			brew install ack
			brew install bash-completion
			# brew install brew-cask
			brew install ctags
			brew install git
			brew install git-extras
			# brew install graphviz
			brew install grc
			brew install highlight
			# brew install htop-osx
			brew install hub
			brew install imagemagick
			brew install irssi
			# brew install lesspipe nmap
			brew install macvim
			brew install mysql
			brew install nodejs
			brew install postgresql
			# brew install qcachegrind
			brew install reattach-to-user-namespace
			brew install rbenv
			brew install ruby-build
			brew install selenium-server-standalone
			brew install ssh-copy-id
			brew install solr
			brew install terminal-notifier
			brew install the_silver_searcher
			brew install tmux
			brew install tree
			brew install vagrant
			brew install wget

			# installing gcc so rbenv can install
			brew tap homebrew/dupes; brew install apple-gcc42
		fi

		# install ctags patched
		# @url https://github.com/shawncplus/phpcomplete.vim/wiki/Patched-ctags
		if [[ ! -f /usr/local/etc/.ctags_patched_installed ]]; then
			log_info "Installing Ctags Patched"
			cd /usr/local/Library/Formula
			curl https://gist.github.com/cweagans/6141478/raw/aea352bf2914832515a5a1f3529e830c7b97c468/- | git apply
			brew install ctags --HEAD
			sudo touch /usr/local/etc/.ctags_patched_installed
		fi
	else
		log_finish "This is not OSX"
	fi

	return ${E_SUCCESS}
}
