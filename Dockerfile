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

# Fix MPM: sed out all conflicting LoadModule lines for MPMs, keep prefork
RUN sed -i '/mpm_event/s/^/#/' /etc/apache2/mods-enabled/mpm_event.load 2>/dev/null || true && \
    sed -i '/mpm_worker/s/^/#/' /etc/apache2/mods-enabled/mpm_worker.load 2>/dev/null || true && \
    a2enmod mpm_prefork

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/

EXPOSE 80
