watch ('.*\.php$') {|phpFile| system("clear && composer dump-autoload && rm bootstrap/compiled.php 2> /dev/null; phpunit")}
