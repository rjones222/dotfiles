watch ('.*[^blade]\.php$') {|phpFile| system("~/.dotfiles/support/observr/phpunit_notify.sh")}
