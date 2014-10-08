#!/usr/bin/env bash
log_info "Beginning bash install script"

link_this "$HOME/.dotfiles/to_link/.bashrc" "$HOME/.bashrc"
link_this "$HOME/.dotfiles/to_link/.bash_profile" "$HOME/.bash_profile"

log_info "End bash install script"
