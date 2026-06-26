FROM php:8.1-apache-bullseye

# Install MySQL extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Enable rewrite
RUN a2enmod rewrite

# Use Railway PORT env var (default 8080)
RUN sed -i 's/^Listen 80/Listen ${PORT:-8080}/' /etc/apache2/ports.conf

COPY . /var/www/html/

RUN chown -R www-data:www-data /var/www/html/ && chmod -R 755 /var/www/html/
