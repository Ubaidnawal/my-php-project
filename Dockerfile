FROM php:8.1-apache
RUN docker-php-ext-install pdo pdo_mysql mysqli
RUN a2enmod rewrite
RUN a2dismod mpm_event && a2enmod mpm_prefork
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
EXPOSE 80
