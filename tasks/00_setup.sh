#!/usr/bin/env bash

function setup_init() {
	task_setup "setup" "Setup" "Prepare to install"
}

function setup_run() {
	# verify sudo
	# if [[ $UID != 0 ]]; then
	# 	log_info "Sudo requested"
	# 	echo "Please run this script with sudo:"
	# 	echo "sudo $0 $*"
	# 	exit 1
	# fi

	# create this if it doesn't exist - we'll need it later.
	sudo mkdir -p /usr/local/bin

	# Ensure that we can actually, like, compile anything.
	if [[ ! "$(type -P gcc)" && "$OSTYPE" =~ ^darwin ]]; then
		log_error "XCode or the Command Line Tools for XCode must be installed first."
		return ${E_FAILURE}
	fi

	# If Git is not installed, install it (Ubuntu only, since Git comes standard
	# with recent XCode or CLT)
	if [[ ! "$(type -P git)" && "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
		log_info "Installing Git"
		sudo apt-get -qq install git-core
	fi

	# If Git isn't installed by now, something exploded. We gots to quit!
	if [[ ! "$(type -P git)" ]]; then
		log_error "Git should be installed. It isn't. Aborting."
		return ${E_FAILURE}
	fi

	# Download or update.
	if [[ ! -d ~/.dotfiles ]]; then
		log_info "New dotfiles install"
		new_dotfiles_install=1

		# ~/.dotfiles doesn't exist? Clone it!
		log_info "Downloading dotfiles"
		cd
		git clone --recursive https://github.com/mikedfunk/dotfiles.git ~/.dotfiles
		cd ~/.dotfiles
	else

		# Make sure we have the latest files.
		log_info "Updating dotfiles"
		cd ~/.dotfiles
		git pull
		git submodule update --init --recursive --quiet
	fi
}
