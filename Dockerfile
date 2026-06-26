FROM dunglas/frankenphp:1-php8.2

# Install PHP extensions
RUN install-php-extensions pdo pdo_mysql mysqli

# Copy project files
COPY . /app

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 755 /app

# Set document root
RUN echo "frankenphp {\n    document_root /app/Website\n}\n" > /app/Caddyfile
