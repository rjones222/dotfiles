#!/usr/bin/env bash

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
        backup_dir="$HOME/Backup/"
        [[ -d "$backup_dir" ]] || sudo mkdir -p "$backup_dir"

        # move the file to the backup dir and notify
        log_info "backing up $2"
        sudo mv $2 $backup_dir
    fi

    # else symlink it and notify
    log_info "linking $1 to $2"
    sudo ln -s $1 $2
}

# display a success message
function log_info() {
    echo "$Green----------------------"
    echo "$1"
    echo "----------------------$Color_Off"
}

# display a error message
function log_error() {
    echo "$Red----------------------"
    echo "$1"
    echo "----------------------$Color_Off"
}

# display a yellow notice message
function log_notice() {
    echo "$Yellow----------------------"
    echo "$1"
    echo "----------------------$Color_Off"
}
