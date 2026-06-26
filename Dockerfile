FROM php:8.1-apache

# Fix MPM conflict head-on
RUN sed -i 's/^LoadModule mpm_event_module/## LoadModule mpm_event_module/' /etc/apache2/apache2.conf && \
    sed -i 's/^LoadModule mpm_worker_module/## LoadModule mpm_worker_module/' /etc/apache2/apache2.conf && \
    echo "LoadModule mpm_prefork_module /usr/lib/apache2/modules/mod_mpm_prefork.so" >> /etc/apache2/apache2.conf && \
    rm -f /etc/apache2/mods-enabled/mpm_event.load /etc/apache2/mods-enabled/mpm_event.conf /etc/apache2/mods-available/mpm_event.load && \
    rm -f /etc/apache2/mods-enabled/mpm_worker.load /etc/apache2/mods-enabled/mpm_worker.conf /etc/apache2/mods-available/mpm_worker.load

# Enable rewrite
RUN a2enmod rewrite

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Copy project files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/
