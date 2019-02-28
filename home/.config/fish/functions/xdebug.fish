function xdebug
	switch $argv[1]
	case 'on'
	    sudo phpenmod xdebug
            set --export --global XDEBUG_CONFIG 'idekey=PHPSTORM'
            echo Xdebug activated
	case 'off'
	    sudo phpdismod xdebug
            set --erase XDEBUG_CONFIG
	    echo Xdebug deactivated
    end
end
