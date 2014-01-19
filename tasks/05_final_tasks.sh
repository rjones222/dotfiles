#!/usr/bin/env bash

function final_tasks_init() {
    task_setup "final_tasks" "Final Tasks" "Install stuff that requires symlinks." "symlinks"
}

function final_tasks_run() {
    # install spf13
    log_info "Installing Spf13-vim"
    curl http://j.mp/spf13-vim3 -L -o - | bash
    rm -rf ~/.vim/bundle/csapprox
    vim +BundleClean! +qall!

    # this needs to be after the .vim folder is created
    log_info "linking UltiSnips custom snippets dir"
    link_this "$HOME/.dotfiles/UltiSnips" "$HOME/.vim/UltiSnips"

    log_info "reloading .bash_profile"
    source ~/.bash_profile
    return ${E_SUCCESS}
}
