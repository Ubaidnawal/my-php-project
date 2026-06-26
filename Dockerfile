FROM php:8.2-apache

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libpng-dev \
        libjpeg-dev \
        libfreetype6-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli gd \
    && a2enmod rewrite

# Fix MPM: remove conflicting symlinks
RUN rm -f /etc/apache2/mods-enabled/mpm_event.load \
          /etc/apache2/mods-enabled/mpm_event.conf \
          /etc/apache2/mods-enabled/mpm_worker.load \
          /etc/apache2/mods-enabled/mpm_worker.conf && \
    a2enmod mpm_prefork

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

EXPOSE 80
