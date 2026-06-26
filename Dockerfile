FROM dunglas/frankenphp:1-php8.2

# Install PHP extensions
RUN install-php-extensions pdo pdo_mysql mysqli

# Copy project files
COPY . /app

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 755 /app

# Create custom Caddyfile for Railway - use PORT env var, no TLS
RUN echo '{' > /app/Caddyfile && \
    echo '    auto_https off' >> /app/Caddyfile && \
    echo '    admin off' >> /app/Caddyfile && \
    echo '}' >> /app/Caddyfile && \
    echo '' >> /app/Caddyfile && \
    echo ':'$PORT':80 {' >> /app/Caddyfile && \
    echo '    root * /app/Website' >> /app/Caddyfile && \
    echo '    php_server' >> /app/Caddyfile && \
    echo '}' >> /app/Caddyfile
