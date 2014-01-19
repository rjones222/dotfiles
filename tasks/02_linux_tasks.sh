#!/usr/bin/env bash

function linux_tasks_init() {
	task_setup "linux_tasks" "Linux Tasks" "Execute tasks only if on Linux" "setup"
}

function linux_tasks_run() {
	# Linux only
	if [[ "$(type -P apt-get)" ]]; then

	    # install linux packages
	    log_info "Installing apt-get Packages"

	    sudo apt-get install -y openjdk-7-jre
	    sudo apt-get install -y git
	    sudo apt-get install -y git-core
	    sudo apt-get install -y openssh-client
	    sudo apt-get install -y openssh-server
	    sudo apt-get install -y postfix
	    sudo apt-get install -y cronolog
	    sudo apt-get install -y apache2
	    sudo apt-get install -y imagemagick
	    sudo apt-get install -y postgresql
	    sudo apt-get install -y postgresql-contrib
	    sudo apt-get install -y pgadmin3
	    sudo apt-get install -y php5
	    sudo apt-get install -y libapache2-mod-php5
	    sudo apt-get install -y php5-xdebug
	    sudo apt-get install -y php5-imagick
	    sudo apt-get install -y php-apc
	    sudo apt-get install -y php5-cli
	    sudo apt-get install -y php5-pgsql
	    sudo apt-get install -y php5-curl
	    sudo apt-get install -y vim

	    sudo apt-get install -y ack
	    sudo apt-get install -y ctags
	    sudo apt-get install -y git-extras
	    sudo apt-get install -y grc
	    sudo apt-get install -y highlight
	    sudo apt-get install -y htop
	    sudo apt-get install -y irssi
	    sudo apt-get install -y php5-json
	    sudo apt-get install -y php-pear
	    sudo apt-get install -y postgresql
	    sudo apt-get install -y rake
	    # sudo apt-get install -y rbenv
	    sudo apt-get install -y silversearcher-ag
	    sudo apt-get install -y solr-tomcat
	    sudo apt-get install -y tmux
	    sudo apt-get install -y tree
	    # sudo apt-get install -y vagrant
	    # sudo apt-get install -y vim
	    # sudo apt-get install vim-nox

	    # install npm for ubuntu 13.04 64 bit
	    sudo apt-get install python-software-properties python g++ make
	    sudo add-apt-repository ppa:chris-lea/node.js
	    sudo apt-get update
	    sudo apt-get install -y nodejs

	    # install rbenv
	    if hash rbenv 2>/dev/null; then
		log_info "rbenv already installed"
	    else
		log_info "Installing rbenv"
		curl https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash
	    fi

		if [[ ! "$(type -P rake)" ]]; then
			log_error "rake not installed"
			return ${E_FAILURE}
		fi

	    # install github's hub
	    if hash hub 2>/dev/null; then
		log_info "Hub already installed"
	    else
		log_info "Installing hub"
		cd ~/.dotfiles/hub
		sudo rake install
	    fi

	fi
	return ${E_SUCCESS}
}
