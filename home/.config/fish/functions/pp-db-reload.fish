function pp-db-reload
        cd ~/projects/_ITW/DuoCirclePhishProtectionDocker;
        docker-compose exec php_portal bash -c "php cli/database.php init; composer m:u; php cli/database.php dummy";
end
