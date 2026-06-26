FROM dunglas/frankenphp:1-php8.2
RUN install-php-extensions pdo pdo_mysql mysqli
COPY . /app
RUN chown -R www-data:www-data /app && chmod -R 755 /app
