FROM php:8.1-apache

# Disable conflicting MPM modules (mpm_event conflicts with mpm_prefork)
RUN if [ -f /etc/apache2/mods-enabled/mpm_event.load ]; then \
        a2dismod mpm_event; \
    fi && \
    if [ -f /etc/apache2/mods-enabled/mpm_worker.load ]; then \
        a2dismod mpm_worker; \
    fi && \
    a2enmod mpm_prefork

# Enable mod_rewrite
RUN a2enmod rewrite

# Install PDO MySQL and other required extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Copy all project files first
COPY . /var/www/html/

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/
