#!/bin/bash

if [ "$ENABLE_XDEBUG" = "true" ]; then
        echo -n "Enabling XDebug..."
        docker-php-ext-enable xdebug
fi

if [ "$ENABLE_SENDMAIL" == "true" ]; then
	echo -n "Executing Sendmail..."
	line=$(head -n 1 /etc/hosts)
	line2=$(echo $line | awk '{print $2}')
	echo "$line $(hostname)  $line2.localdomain" >> /etc/hosts
	/etc/init.d/sendmail start
fi

if [ "$INSTALL_MAGENTO" = "true" ]; then
        echo -n "Installing Magento..."
	chown -R www-data:www-data /var/www/
	echo -n "Cloning GIT repo ..."
	git clone https://github.com/magento/magento2.git /var/www/html/
	cd /var/www/html/
	echo -n "Composer install..."
	sudo -u www-data composer install && chown -R www-data:www-data pub/static pub/media var generated app/etc
	
	sudo -u www-data php bin/magento setup:install --db-host=$MAGENTO_MYSQL_HOST --db-name=$MAGENTO_MYSQL_DB --db-user=$MAGENTO_MYSQL_USER --db-password=$MAGENTO_MYSQL_PASSWORD --base-url=$MAGENTO_URL --backend-frontname=admin --admin-user=$MAGENTO_ADMIN_USER --admin-password=$MAGENTO_ADMIN_PASSWORD --admin-email=$MAGENTO_ADMIN_EMAIL --admin-firstname=Admin --admin-lastname=Admin --language=en_US --currency=USD --timezone=America/Chicago --skip-db-validation --session-save=redis --session-save-redis-host=$MAGENTO_SESSION_REDIS_HOST --cache-backend=redis --cache-backend-redis-server=$MAGENTO_CACHE_REDIS_HOST --page-cache=redis --page-cache-redis-server=$MAGENTO_FPC_REDIS_HOST --http-cache-hosts=$MAGENTO_HTTP_CACHE_HOST

	echo -n "Done..."
fi

if [ "$RESET_MAGENTO_MODE" = "true" ]; then 
	echo -n "Configuring MAGENTO MODE:"
	sudo -u www-data php bin/magento deploy:mode:set $MAGENTO_MODE
	echo -n "Done"
fi

echo -n "Executing Arguments..."
exec "$@"
