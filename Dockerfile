FROM php:8.2-fpm

WORKDIR /app

# Install only essential runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl zip unzip sqlite3 nginx supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install only essential PHP extensions (no gd or calendar to avoid compilation issues)
RUN docker-php-ext-install pdo pdo_sqlite pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application
COPY . /app

# Install composer dependencies
RUN composer install --no-interaction --no-dev 2>&1 | grep -v "^$"

# Generate Laravel key
RUN php artisan key:generate --force 2>&1 || true

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 775 /app/storage /app/bootstrap/cache

# Configure PHP
RUN echo "upload_max_filesize=100M\npost_max_size=100M\nmemory_limit=512M" > /usr/local/etc/php/conf.d/laravel.ini

# Configure Nginx
RUN echo 'user www-data; worker_processes auto; error_log /var/log/nginx/error.log; pid /var/run/nginx.pid; events { worker_connections 1024; } http { include /etc/nginx/mime.types; default_type application/octet-stream; sendfile on; keepalive_timeout 65; client_max_body_size 100M; server { listen 80; root /app/public; index index.php; location / { try_files $uri $uri/ /index.php?$query_string; } location ~ \.php$ { fastcgi_pass 127.0.0.1:9000; fastcgi_index index.php; include fastcgi_params; fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; } } }' > /etc/nginx/nginx.conf

# Configure Supervisor
RUN mkdir -p /var/log/supervisor && echo '[supervisord]\nnodaemon=true\nuser=root\n\n[program:php-fpm]\ncommand=/usr/local/sbin/php-fpm\nautostart=true\nautorestart=true\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g "daemon off;"\nautostart=true\nautorestart=true' > /etc/supervisor/conf.d/laravel.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
