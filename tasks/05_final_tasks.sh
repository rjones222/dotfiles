#!/usr/bin/env bash

function vim_init() {
    task_setup "vim" "Vim" "Gets vim going. Works best after symlinks." "symlinks"
}

function vim_run() {

    # install spf13
    if [[ ! -d ~/.spf13-vim-3/ ]]; then
        log_info "Installing Spf13-vim"
        curl http://j.mp/spf13-vim3 -L -o - | bash
        rm -rf ~/.vim/bundle/csapprox
        vim +BundleClean! +qall!
    else
        log_info "Updating vim bundles"
        vim +BundleUpdate +qall!
    fi

    # build vim plugin buildables
    if [[ ! "$(type -P phpctags)" ]]
        cd ~/.vim/bundle/vim-plugin-tagbar-phpctags/
        make
        cd ~/.vim/bundle/vimproc
        make
        cd -
    fi

    # this needs to be after the .vim folder is created
    log_info "linking UltiSnips custom snippets dir"
    link_this "$HOME/.dotfiles/to_link/UltiSnips" "$HOME/.vim/UltiSnips"

    #log_info "reloading .bash_profile"
    #source ~/.bash_profile
    return ${E_SUCCESS}
}
