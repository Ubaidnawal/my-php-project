FROM php:8.2-apache-bookworm
RUN apt-get update && apt-get install -y apache2 && \
    rm -f /etc/apache2/mods-enabled/mpm_event.* /etc/apache2/mods-enabled/mpm_worker.* && \
    a2enmod mpm_prefork && \
    docker-php-ext-install pdo pdo_mysql mysqli && \
    a2enmod rewrite && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
EXPOSE 80
