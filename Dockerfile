FROM php:8.1-apache

# Fix MPM conflict - remove all MPM enabled configs and enable only prefork
RUN rm -f /etc/apache2/mods-enabled/mpm_event.* \
    rm -f /etc/apache2/mods-enabled/mpm_worker.* \
    a2enmod mpm_prefork

# Enable mod_rewrite
RUN a2enmod rewrite

# Install PDO MySQL extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Copy project files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/
