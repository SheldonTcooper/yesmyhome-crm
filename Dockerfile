FROM php:8.2-fpm

WORKDIR /app

# Install all dependencies upfront
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl zip unzip sqlite3 libsqlite3-dev nginx supervisor \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) pdo pdo_sqlite pdo_mysql bcmath

# Install Composer first (before copying code)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files
COPY . /app

# Install composer dependencies (MUST happen after COPY)
RUN cd /app && composer install --no-interaction --optimize-autoloader --no-dev

# Generate Laravel key
RUN cd /app && php artisan key:generate --force

# Set permissions
RUN chown -R www-data:www-data /app && chmod -R 775 /app/storage /app/bootstrap/cache

# Configure PHP
RUN echo "upload_max_filesize = 100M\npost_max_size = 100M\nmemory_limit = 512M\ndate.timezone = America/Sao_Paulo" > /usr/local/etc/php/conf.d/laravel.ini

# Configure Nginx
RUN echo 'user www-data; \
worker_processes auto; \
error_log /var/log/nginx/error.log; \
pid /var/run/nginx.pid; \
events { worker_connections 1024; } \
http { \
  include /etc/nginx/mime.types; \
  default_type application/octet-stream; \
  sendfile on; \
  keepalive_timeout 65; \
  client_max_body_size 100M; \
  server { \
    listen 80; \
    root /app/public; \
    index index.php index.html; \
    location / { \
      try_files $uri $uri/ /index.php?$query_string; \
    } \
    location ~ \.php$ { \
      fastcgi_pass 127.0.0.1:9000; \
      fastcgi_index index.php; \
      include fastcgi_params; \
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; \
    } \
  } \
}' > /etc/nginx/nginx.conf

# Configure Supervisor
RUN mkdir -p /var/log/supervisor && echo '[supervisord] \
nodaemon=true \
user=root \
\
[program:php-fpm] \
command=/usr/local/sbin/php-fpm \
autostart=true \
autorestart=true \
stderr_logfile=/var/log/supervisor/php-fpm.err.log \
stdout_logfile=/var/log/supervisor/php-fpm.out.log \
\
[program:nginx] \
command=/usr/sbin/nginx -g "daemon off;" \
autostart=true \
autorestart=true \
stderr_logfile=/var/log/supervisor/nginx.err.log \
stdout_logfile=/var/log/supervisor/nginx.out.log' > /etc/supervisor/conf.d/laravel.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD curl -f http://localhost/ || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
