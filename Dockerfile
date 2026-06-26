FROM php:8.2-cli

# Install Apache and PHP libapache2-mod-php
RUN apt-get update && \
    apt-get install -y apache2 libapache2-mod-php8.2 && \
    a2enmod rewrite && \
    docker-php-ext-install pdo pdo_mysql mysqli && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/

# Use the standard Apache entrypoint
CMD ["apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80
