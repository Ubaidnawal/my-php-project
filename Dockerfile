FROM dunglas/frankenphp:1-php8.2
RUN install-php-extensions pdo pdo_mysql mysqli
COPY . /app
RUN chown -R www-data:www-data /app
RUN cat > /etc/frankenphp/Caddyfile << 'CADDY'
{
	auto_https off
	admin off
	frankenphp
}
:{$PORT:80} {
	root * /app/Website
	php_server

	route /ajax/* {
		uri strip_prefix /ajax
		root * /app/ajax
		php_server
	}
	route /admin/* {
		uri strip_prefix /admin
		root * /app/admin
		php_server
	}
	route /assets/* {
		root * /app/assets
		file_server
	}
	route /Image/* {
		root * /app/Image
		file_server
	}
}
CADDY
