watch ('.*\.php$') {|phpFile| system("source ~/.profile && clear && composer dump-autoload && rm bootstrap/compiled.php 2> /dev/null; phpunitnotify")}
