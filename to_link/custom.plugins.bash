cite about-plugin
about-plugin "custom plugins"

# ----------------------------------------
# functions

# phpunit with notification
phpunitnotify () {
    about 'runs phpunit and uses terminal-notifier to show the results'
    group 'custom'

    /usr/local/php5/bin/phpunit "${@}"
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

# drops and creates einstein2 database
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

# ls after every cd
cd() {
    builtin cd "$@" && ls;
}
