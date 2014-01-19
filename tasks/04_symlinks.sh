#!/usr/bin/env bash

function symlinks_init() {
    task_setup "symlinks" "Create Symlinks" "Create Symbolic Links" "install"
}

function link_this() {
    # if the file/dir to link doesn't exist
    if [[ ! -f "$1" ]] && [[ ! -d "$1" ]]; then
        log_error "file/directory $1 does not exist"
    return ${E_FAILURE}

    # if the symlink exists, skip it and notify
    elif [[ -L "$2" ]]; then
        log_info "symlink $2 exists"
        return

    # if the file already exists
    elif [[ -f $2 || -d $2 ]]; then

        # create a backup dir if it doesn't already exist and notify
    log_info "creating backup directory"
        backup_dir = "$HOME/backup/"
        [[ -d "$backup_dir" ]] || sudo mkdir -p "$backup_dir"

        # move the file to the backup dir and notify
        log_info "backing up $2"
        sudo mv $2 $backup_dir

    # else symlink it and notify
    else
        log_info "linking $1 to $2"
        sudo ln -s $1 $2
    fi
}

function symlinks_run() {

    link_this "$HOME/.dotfiles/gitconfig" "$HOME/.gitconfig"
    link_this "$HOME/.dotfiles/gitignore" "$HOME/.gitignore"
    link_this "$HOME/.dotfiles/config" "$HOME/.config"
    link_this "$HOME/.dotfiles/ssh/config" "$HOME/.ssh/config"
    link_this "$HOME/.dotfiles/ctags" "$HOME/.ctags"

    link_this "$HOME/.dotfiles/profile" "$HOME/.profile"
    link_this "$HOME/.dotfiles/ps1" "$HOME/.ps1"
    link_this "$HOME/.dotfiles/bashrc" "$HOME/.bashrc"
    link_this "$HOME/.dotfiles/bash_profile" "$HOME/.bash_profile"
    link_this "$HOME/.dotfiles/irssi" "$HOME/.irssi"

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
    # link_this "$HOME/rbenv" "$HOME/.rbenv"
    link_this "/var/www/sites" "$HOME/Sites"
    link_this "/Library/WebServer/Documents" "$HOME/Sites"

    # link_this "$HOME/.dotfiles/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
    # sudo ln -s $HOME/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

    return ${E_SUCCESS}
}
