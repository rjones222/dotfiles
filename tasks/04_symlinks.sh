#!/usr/bin/env bash

function symlinks_init() {
    task_setup "symlinks" "Create Symlinks" "Create Symbolic Links" "install"
}

function link_this() {
    # if the file/dir to link doesn't exist
    if [[ ! -f "$1" ]] && [[ ! -d "$1" ]]; then
        log_error "file/directory $1 does not exist"
        return ${E_FAILURE}
    fi

    # if the symlink exists, skip it and notify
    if [[ -L "$2" ]]; then
        log_info "symlink $2 exists"
        return
    fi

    # if the file already exists
    if [[ -f $2 || -d $2 ]]; then

        # create a backup dir if it doesn't already exist and notify
        log_info "creating backup directory"
        backup_dir="$HOME/backup/"
        [[ -d "$backup_dir" ]] || sudo mkdir -p "$backup_dir"

        # move the file to the backup dir and notify
        log_info "backing up $2"
        sudo mv $2 $backup_dir
    fi

    # else symlink it and notify
    log_info "linking $1 to $2"
    sudo ln -s $1 $2
}

function symlinks_run() {

    link_this "$HOME/.dotfiles/to_link/.gitconfig" "$HOME/.gitconfig"
    link_this "$HOME/.dotfiles/to_link/.gitignore" "$HOME/.gitignore"
    link_this "$HOME/.dotfiles/to_link/.config" "$HOME/.config"
    link_this "$HOME/.dotfiles/to_link/.ssh" "$HOME/.ssh"
    link_this "$HOME/.dotfiles/to_link/.ctags" "$HOME/.ctags"
    link_this "$HOME/.dotfiles/to_link/.irssi" "$HOME/.irssi"

    link_this "$HOME/.dotfiles/to_link/.screenrc" "$HOME/.screenrc"
    link_this "$HOME/.dotfiles/to_link/.tmux.conf" "$HOME/.tmux.conf"
    link_this "$HOME/.dotfiles/to_link/.grcat" "$HOME/.grcat"
    link_this "$HOME/.dotfiles/to_link/.my.cnf" "$HOME/.my.cnf"
    link_this "$HOME/.dotfiles/to_link/.my.ini" "$HOME/.my.ini"

    link_this "$HOME/.dotfiles/to_link/.inputrc" "$HOME/.inputrc"
    link_this "$HOME/.dotfiles/to_link/.rainbarf.conf" "$HOME/.rainbarf.conf"
    link_this "$HOME/.dotfiles/to_link/.vimrc.bundles.local" "$HOME/.vimrc.bundles.local"
    link_this "$HOME/.dotfiles/to_link/.vimrc.local" "$HOME/.vimrc.local"
    link_this "$HOME/.dotfiles/to_link/.vimrc.before.local" "$HOME/.vimrc.before.local"

    # in bashit task
    # link_this "$HOME/.dotfiles/to_link/custom.aliases.bash" "$HOME/.bash_it/aliases/custom.aliases.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.plugins.bash" "$HOME/.bash_it/plugins/custom.plugins.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.theme.bash" "$HOME/.bash_it/custom/custom.theme.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.bash" "$HOME/.bash_it/lib/custom.bash"

    link_this "$HOME/.dotfiles/to_link/.tmuxinator" "$HOME/.tmuxinator"
    link_this "/var/www/sites" "$HOME/Sites"
    link_this "/Library/WebServer/Documents" "$HOME/Sites"

    link_this "$HOME/.dotfiles/bin" "$HOME/.bin"

    # link_this "$HOME/.dotfiles/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
    # sudo ln -s $HOME/.dotfiles/999-my-httpd.conf /etc/apache2/other/999-my-httpd.conf

    return ${E_SUCCESS}
}
