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
echo -e "$(tput setaf 2)$(tput rev)$(tput bold) \xE2\x9C\x93 $1 $(tput sgr0)"
}

# display a error message
function log_error() {
echo -e "$(tput setaf 1)$(tput rev)$(tput bold) \xE2\x9C\x97 $1 $(tput sgr0)"
}

# display a yellow notice message
function log_notice() {
echo -e "$(tput setaf 3)$(tput rev)$(tput bold) \xE2\x9A\xa0 $1 $(tput sgr0)"
}
