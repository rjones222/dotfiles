#!/usr/bin/env bash
log_info "Beginning bash install script"

link_this "$HOME/.dotfiles/to_link/bash/.bashrc" "$HOME/.bashrc"
link_this "$HOME/.dotfiles/to_link/bash/.bash_profile" "$HOME/.bash_profile"
link_this "$HOME/.dotfiles/to_link/bash/.bash_aliases" "$HOME/.bash_aliases"
link_this "$HOME/.dotfiles/to_link/bash/.bash_functions" "$HOME/.bash_functions"

link_this "$HOME/.dotfiles/to_link/bash/.bash_paths" "$HOME/.bash_paths"
link_this "$HOME/.dotfiles/to_link/bash/.bash_env" "$HOME/.bash_env"
link_this "$HOME/.dotfiles/to_link/promptline.theme.bash" "$HOME/.promptline.theme.bash"

# try to add some more bash completions somewhere
# link_this "$HOME/.dotfiles/to_link/bash_completion/misc.bash" "/usr/local/etc/bash_completion.d/misc.bash"
# link_this "$HOME/.dotfiles/to_link/bash_completion.d/misc.bash" "/etc/bash_completion.d/misc.bash"

log_info "End bash install script"
