FROM php:8.1-apache

# Fix MPM conflict - disable all MPMs then enable prefork
RUN a2dismod mpm_event mpm_worker || true && \
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

# Override Apache entrypoint to ensure clean MPM config
RUN echo "" > /etc/apache2/mods-enabled/mpm_event.load 2>/dev/null || true && \
    echo "" > /etc/apache2/mods-enabled/mpm_worker.load 2>/dev/null || true && \
    test -f /etc/apache2/mods-enabled/mpm_prefork.load || \
    ln -s /etc/apache2/mods-available/mpm_prefork.load /etc/apache2/mods-enabled/mpm_prefork.load
