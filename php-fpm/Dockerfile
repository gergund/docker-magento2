FROM php:7.1-fpm
COPY --from=composer:1.5 /usr/bin/composer /usr/bin/composer
RUN apt-get update && apt-get install -y \
	git \ 
	netcat \
	mysql-client \
	libfreetype6-dev \
	libicu-dev \
	libjpeg62-turbo-dev \
	libmcrypt-dev \
	libpng-dev \
	libxslt1-dev \
	sendmail-bin \
	sendmail \
	sudo

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  dom \ 
  gd \ 
  intl \ 
  mbstring \ 
  pdo_mysql \ 
  xsl \ 
  zip \ 
  soap \ 
  bcmath \ 
  mcrypt

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN git clone https://github.com/magento/magento2.git /var/www/html/

WORKDIR /var/www/html/

RUN composer install && chown -R www-data:www-data pub/static pub/media var generated app/etc

CMD php bin/magento setup:install --db-host=mysql --db-name=magento --db-user=magento --db-password=magento --base-url=http://docker.magento.loc --backend-frontname=admin --admin-user=admin --admin-password=123123qa --admin-email=gergund@gmail.com --admin-firstname=Admin --admin-lastname=Admin --language=en_US --currency=USD --timezone=America/Chicago --skip-db-validation --session-save=redis --session-save-redis-host=redis --cache-backend=redis --cache-backend-redis-server=redis --page-cache=redis --page-cache-redis-server=redis \
&& chown -R root:root /var/www/html/app/etc \
&& chown -R www-data:www-data pub/static pub/media var generated \
&& php-fpm
