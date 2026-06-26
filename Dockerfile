FROM dunglas/frankenphp:1-php8.2

# Install PHP extensions
RUN install-php-extensions pdo pdo_mysql mysqli

# Copy project files
COPY . /app

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 755 /app

# Override default FrankenPHP config to listen on port 80 for Railway
# (Railway's proxy handles HTTPS)
COPY --from=ghcr.io/dunglas/frankenphp:1-php8.2 /usr/local/bin/frankenphp /usr/local/bin/frankenphp
RUN mkdir -p /etc/frankenphp && \
    echo '{' > /etc/frankenphp/Caddyfile && \
    echo '    auto_https off' >> /etc/frankenphp/Caddyfile && \
    echo '    admin off' >> /etc/frankenphp/Caddyfile && \
    echo '}' >> /etc/frankenphp/Caddyfile && \
    echo ':80' >> /etc/frankenphp/Caddyfile && \
    echo 'root * /app/Website' >> /etc/frankenphp/Caddyfile && \
    echo 'php_server' >> /etc/frankenphp/Caddyfile && \
    echo '}' >> /etc/frankenphp/Caddyfile
