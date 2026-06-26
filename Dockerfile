FROM php:8.1-apache

# Install PHP MySQL extensions
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Enable Apache rewrite module
RUN a2enmod rewrite

# Configure Apache to listen on Railway's PORT env var (default 8080)
RUN sed -i 's/Listen 80/Listen ${PORT:-8080}/g' /etc/apache2/ports.conf && \
    sed -i 's/:80/:${PORT:-8080}/g' /etc/apache2/sites-available/000-default.conf

# Copy project files
COPY . /var/www/html/

# Set permissions
RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 755 /var/www/html/
