#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function vim_init() {
    task_setup "vim" "Vim" "Customize Vim" "symlinks"
    . ~/.dotfiles/support/install_functions.sh
}

function make_vimproc() {
    log_info "Attempting to build vimproc"
    cd ~/.vim/bundle/vimproc
    make
    cd -
}

function make_youcompleteme() {
    log_info "Attempting to build youcompleteme"
    cd ~/.vim/bundle/YouCompleteMe
    ./install.sh
    cd -
}

function vim_run() {

    # install spf13
    if [[ ! -d ~/.spf13-vim-3/ ]]; then
        log_info "Installing Spf13-vim"
        curl http://j.mp/spf13-vim3 -L -o - | bash
        rm -rf ~/.vim/bundle/csapprox
        make_vimproc
        make_youcompleteme
        vim +BundleClean! +qall!
    else
        log_info "Updating vim bundles"
        vim +BundleUpdate +qall!
        make_vimproc
        make_youcompleteme
    fi

    # build vim plugin buildables
    if [[ ! "$(type -P phpctags)" ]]; then
        log_info "Building phpctags"
        cd ~/.vim/bundle/vim-plugin-tagbar-phpctags/
        make
    fi

    # this needs to be after the .vim folder is created
    log_info "linking UltiSnips custom snippets dir"
    link_this "$HOME/.dotfiles/to_link/UltiSnips" "$HOME/.vim/UltiSnips"
    log_info "linking NERDTree plugins"
    link_this "$HOME/.dotfiles/to_link/open_multiple.vim" "$HOME/.vim/bundle/nerdtree/nerdtree_plugin/"

    #log_info "reloading .bash_profile"
    #source ~/.bash_profile
    return ${E_SUCCESS}
}
