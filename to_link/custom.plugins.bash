cite about-plugin
about-plugin "custom plugins"

# ----------------------------------------
# functions

phpunitnotify () {
    about 'runs phpunit and uses terminal-notifier to show the results'
    group 'custom'

    phpunit "${@}"
    if [[ $? == 0 ]]; then
        terminal-notifier -message "PHPUnit tests passed" -title "Passed" -activate "com.apple.Terminal";
    else
        terminal-notifier -message "PHPUnit tests failed" -title "Failed" -activate "com.apple.Terminal";
    fi
}

mkdircd () {
    about 'makes a directory and immediately cds into it'
    group 'custom'

    mkdir -p "$@" && eval cd "\"\$$#\"";
}

dbreset() {
    about 'drops and creates a specific database'
    group 'custom'

    # drop database, create database
    echo "${GREEN}drop database${RESET}"
    mysql -uroot -e 'DROP DATABASE IF EXISTS einstein2;'

    echo "${GREEN}create database${RESET}"
    mysql -uroot -e 'CREATE DATABASE IF NOT EXISTS einstein2;'

    # migrate database, seed database
    php artisan migrate
    php artisan db:seed
}

cd() {
    about 'ls after every cd'
    group 'custom'

    builtin cd "$@" && ls;
}

pcs() {
    about 'use phpcs.xml if exists'
    group 'custom'

    echo "Sniffing for coding standards violations..."
    if [[ -f "phpcs.xml" ]]; then
        phpcs --standard=phpcs.xml -p .
    else
        phpcs **/*.php
    fi
}

togglexdebug() {
    about 'toggle local xdebug on or off'
    group 'custom'

    XDEBUGPATH="/usr/local/php5/php.d/50-extension-xdebug.ini"
    XDEBUGDIS="${XDEBUGPATH}.disabled"
    if [[ -f $XDEBUGPATH ]]; then
        echo "Disabling Xdebug"
        sudo mv $XDEBUGPATH $XDEBUGDIS
        sudo apachectl restart
    elif [[ -f $XDEBUGDIS ]]; then
        echo "Enabling Xdebug"
        sudo mv $XDEBUGDIS $XDEBUGPATH
        sudo apachectl restart
    else
        echo "Xdebug ini file not found!"
    fi
}

isxdebugon() {
    about 'tell me whether xdebug is enabled'
    group 'custom'

    if [[ "$(php -i | grep xdebug)" ]]; then
        echo 'xdebug is ON'
    else
        echo 'xdebug is OFF'
    fi
}

upgrades() {
    about 'upgrade everything'
    group 'custom'

    echo "Upgrading everything!"
    sudo pear upgrade
    sudo gem update
    sudo npm update -g
    brew update
    brew upgrade
    composer global update
    composer self-update
    php-cs-fixer self-update
    cd ~/.bash_it
    git pull
    cd ~/.spf13-vim-3
    git pull
    cd ~
}

whitespace() {
    about 'strip all trailing whitespace in files in the current dir'
    group 'custom'

    echo "Stripping ALL trailing whitespace in the current dir"
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        # exit 1
        echo "cancelled"
        return
    fi
    echo "proceeding..."
    export LANG=C; find . -not \( -name .svn -prune -o -name .git -prune \) -type f -print0 | xargs -0 sed -i '' -E "s/[[:space:]]\+$//"
}
