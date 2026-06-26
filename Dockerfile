FROM dunglas/frankenphp:1-php8.2

# Install PHP MySQL extensions
RUN install-php-extensions pdo pdo_mysql mysqli

# Copy app files
COPY . /app
RUN chown -R www-data:www-data /app

# Override the default FrankenPHP Caddyfile
COPY Caddyfile /etc/frankenphp/Caddyfile
