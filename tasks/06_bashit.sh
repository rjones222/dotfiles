#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function bashit_init() {
    task_setup "bashit" "bash-it install" "Run bashit framework setup" "symlinks"
}

function bashit_run() {

    if [[ ! -d "$HOME/.bash_it" ]]; then
        log_info "cloning into ~/.bash_it"
        git clone https://github.com/revans/bash-it.git ~/.bash_it
    fi

    # link files that go into ~/.bash_it/
    link_this "$HOME/.dotfiles/to_link/custom.aliases.bash" "$HOME/.bash_it/aliases/custom.aliases.bash"
    link_this "$HOME/.dotfiles/to_link/custom.plugins.bash" "$HOME/.bash_it/custom/custom.plugins.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.theme.bash" "$HOME/.bash_it/custom/custom.theme.bash"
    link_this "$HOME/.dotfiles/to_link/promptline.theme.bash" "$HOME/.bash_it/custom/promptline.theme.bash"
    link_this "$HOME/.dotfiles/to_link/custom.bash" "$HOME/.bash_it/lib/custom.bash"

    bashit_dir="$HOME/.bash_it/install.sh"
    if [[ ! -f $bashit_dir ]]; then
        log_error "bash-it installer not found"
        return ${E_FAILURE}
    fi
    log_info "Running bash-it installer"
    if [[ -f "$HOME/.dotfiles/.bashit.status" ]]; then
        source ~/.dotfiles/.bashit.status
        if [[ $bashit_dependencies == "setup" ]]; then
            log_info "bashit already installed"
            return ${E_SUCCESS}
        fi
    fi
    source $bashit_dir
    return ${E_SUCCESS}
}
