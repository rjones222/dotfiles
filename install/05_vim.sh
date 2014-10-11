#!/usr/bin/env bash
log_info "Beginning vim install script"

link_this "$HOME/.dotfiles/to_link/vim/.vimrc" "$HOME/.vimrc"
link_this "$HOME/.dotfiles/to_link/vim/.vimrc.plugins" "$HOME/.vimrc.plugins"

# create ~/.vim if it doesn't exist
log_info "creating the ~/.vim directory"
[[ ! -d $HOME/.vim ]] && mkdir $HOME/.vim

# this needs to be after the .vim folder is created
log_info "linking UltiSnips custom snippets dir"
link_this "$HOME/.dotfiles/to_link/UltiSnips" "$HOME/.vim/UltiSnips"

log_info "End vim install script"
