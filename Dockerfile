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

	# Static file routes first
	@image {
		path /Image/*
	}
	rewrite @image /Image/{path}
	root @image /app
	file_server @image

	@ajax {
		path /ajax/*
	}
	rewrite @ajax /ajax/{path}
	root @ajax /app/ajax
	php_server @ajax

	@admin {
		path /admin/*
	}
	rewrite @admin /admin/{path}
	root @admin /app/admin
	php_server @admin

	@assets {
		path /assets/*
	}
	root @assets /app/assets
	file_server @assets

	# Everything else to Website
	php_server
}
CADDY
