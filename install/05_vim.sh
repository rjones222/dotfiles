#!/usr/bin/env bash
log_info "Beginning vim install script"

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

function make_tagbarphpctags() {
    log_info "Attempting to build phpctags"
    cd ~/.vim/bundle/tagbar-phpctags.vim/
    make
    cd -
}

# @TODO install vim plugins

# build vim plugin buildables
make_vimproc
make_youcompleteme
make_tagbarphpctags

# this needs to be after the .vim folder is created
log_info "linking UltiSnips custom snippets dir"
link_this "$HOME/.dotfiles/to_link/UltiSnips" "$HOME/.vim/UltiSnips"

log_info "End vim install script"
