#!/usr/bin/env bash

# Modeline and Notes {{{
# vim: set sw=4 ts=4 sts=4 et tw=78 foldmethod=marker:
#
#  ___  ____ _         ______           _
#  |  \/  (_) |        |  ___|         | |
#  | .  . |_| | _____  | |_ _   _ _ __ | | __
#  | |\/| | | |/ / _ \ |  _| | | | '_ \| |/ /
#  | |  | | |   <  __/ | | | |_| | | | |   <
#  \_|  |_/_|_|\_\___| \_|  \__,_|_| |_|_|\_\
#
# link my dotfiles to their expected locations
# more info at http://mikefunk.com
# }}}

# source installer support files {{{
for f in ~/.dotfiles/install/support/*; do source $f; done
# }}}

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
