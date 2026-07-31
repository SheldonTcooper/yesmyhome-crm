FROM php:8.2-fpm

WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip sqlite3 libsqlite3-dev nginx supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install only essential PHP extensions
RUN docker-php-ext-install -j$(nproc) \
    pdo pdo_sqlite pdo_mysql bcmath

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy app
COPY . /app

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 755 /app

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev 2>/dev/null || true

# Generate key
RUN php artisan key:generate --force 2>/dev/null || true

# Configure PHP
RUN echo "upload_max_filesize = 100M" > /usr/local/etc/php/conf.d/laravel.ini && \
    echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/laravel.ini && \
    echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/laravel.ini

# Configure Nginx
RUN mkdir -p /etc/nginx && echo 'user www-data; worker_processes auto; error_log /var/log/nginx/error.log; pid /var/run/nginx.pid; events { worker_connections 1024; } http { include /etc/nginx/mime.types; default_type application/octet-stream; sendfile on; keepalive_timeout 65; client_max_body_size 100M; server { listen 80; root /app/public; index index.php; location / { try_files $uri $uri/ /index.php?$query_string; } location ~ \.php$ { fastcgi_pass 127.0.0.1:9000; fastcgi_index index.php; include fastcgi_params; fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; } } }' > /etc/nginx/nginx.conf

# Configure Supervisor
RUN mkdir -p /var/log/supervisor && echo '[supervisord]\nnodaemon=true\n\n[program:php-fpm]\ncommand=/usr/local/sbin/php-fpm\nautostart=true\nautorestart=true\n\n[program:nginx]\ncommand=/usr/sbin/nginx -g "daemon off;"\nautostart=true\nautorestart=true' > /etc/supervisor/conf.d/laravel.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -f http://localhost/ || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
