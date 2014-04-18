#!/usr/bin/env bash

. ~/.dotfiles/support/install_functions.sh

function symlinks_init() {
    task_setup "symlinks" "Create Symlinks" "Create Symbolic Links" "install"
}

function symlinks_run() {

    link_this "$HOME/.dotfiles/to_link/.gitconfig" "$HOME/.gitconfig"
    link_this "$HOME/.dotfiles/to_link/.gitignore" "$HOME/.gitignore"
    link_this "$HOME/.dotfiles/to_link/.agignore" "$HOME/.agignore"
    link_this "$HOME/.dotfiles/to_link/.config" "$HOME/.config"
    link_this "$HOME/.dotfiles/to_link/.ssh" "$HOME/.ssh"

    link_this "$HOME/.dotfiles/to_link/.ctags" "$HOME/.ctags"
    link_this "$HOME/.dotfiles/to_link/.irssi" "$HOME/.irssi"
    link_this "$HOME/.dotfiles/to_link/.screenrc" "$HOME/.screenrc"
    link_this "$HOME/.dotfiles/to_link/.tmux.conf" "$HOME/.tmux.conf"
    link_this "$HOME/.dotfiles/to_link/.tmate.conf" "$HOME/.tmate.conf"

    link_this "$HOME/.dotfiles/to_link/.grcat" "$HOME/.grcat"
    link_this "$HOME/.dotfiles/to_link/.my.cnf" "$HOME/.my.cnf"
    link_this "$HOME/.dotfiles/to_link/.my.ini" "$HOME/.my.ini"
    link_this "$HOME/.dotfiles/to_link/.composer" "$HOME/.composer"

    link_this "$HOME/.dotfiles/to_link/.inputrc" "$HOME/.inputrc"
    link_this "$HOME/.dotfiles/to_link/.rainbarf.conf" "$HOME/.rainbarf.conf"
    link_this "$HOME/.dotfiles/to_link/.vimrc.bundles.local" "$HOME/.vimrc.bundles.local"
    link_this "$HOME/.dotfiles/to_link/.vimrc.local" "$HOME/.vimrc.local"
    link_this "$HOME/.dotfiles/to_link/.vimrc.before.local" "$HOME/.vimrc.before.local"

    # in bashit task
    # link_this "$HOME/.dotfiles/to_link/custom.aliases.bash" "$HOME/.bash_it/aliases/custom.aliases.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.plugins.bash" "$HOME/.bash_it/plugins/custom.plugins.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.theme.bash" "$HOME/.bash_it/custom/custom.theme.bash"
    # link_this "$HOME/.dotfiles/to_link/custom.bash" "$HOME/.bash_it/lib/custom.bash"

    link_this "$HOME/.dotfiles/to_link/.teamocil" "$HOME/.teamocil"
    link_this "/var/www/sites" "$HOME/Sites"
    link_this "/Library/WebServer/Documents" "$HOME/Sites"
    link_this "$HOME/.dotfiles/to_link/adminer" "$HOME/Sites/adminer"

    link_this "$HOME/.dotfiles/to_link/webgrind" "$HOME/Sites/webgrind"
    link_this "$HOME/.dotfiles/to_link/.jshintrc" "$HOME/.jshintrc"
    link_this "$HOME/.dotfiles/to_link/.ngrok" "$HOME/.ngrok"
    link_this "$HOME/.dotfiles/to_link/.virtualhost.sh.conf" "$HOME/.virtualhost.sh.conf"

    link_this "$HOME/.dotfiles/bin" "$HOME/.bin"
    sudo chmod a+x ~/.bin/*
    link_this "$HOME/.dotfiles/to_link/.bashrc" "$HOME/.bashrc"
    link_this "$HOME/.dotfiles/to_link/.git_template" "$HOME/.git_template"
    sudo chmod a+x ~/.dotfiles/to_link/.git_template/hooks/*

    link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/usr/local/php5/php.d/999-my-php.ini"
    link_this "$HOME/.dotfiles/to_link/999-my-php.ini" "/etc/php5/apache2/conf.d/999-my-php.ini"
    link_this "$HOME/.dotfiles/to_link/999-my-httpd.conf" "/etc/apache2/other/999-my-httpd.conf"
    link_this "$HOME/.dotfiles/to_link/999-my-httpd.conf" "/etc/apache2/conf-available/999-my-httpd.conf"
    link_this "$HOME/.dotfiles/to_link/999-my-httpd.conf" "/etc/apache2/conf-enabled/999-my-httpd.conf"

    log_info "restarting apache"
    # sudo apachectl restart

    return ${E_SUCCESS}
}
