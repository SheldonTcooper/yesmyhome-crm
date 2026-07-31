FROM php:8.2-fpm

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    unzip \
    sqlite3 \
    libsqlite3-dev \
    postgresql-client \
    libpq-dev \
    nginx \
    supervisor \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_sqlite \
    pdo_mysql \
    pdo_pgsql \
    openssl \
    mbstring \
    fileinfo \
    curl \
    zip \
    bcmath \
    ctype \
    json

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files
COPY . /app

# Set permissions
RUN chown -R www-data:www-data /app && \
    chmod -R 755 /app && \
    chmod -R 775 /app/storage /app/bootstrap/cache

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Generate app key
RUN php artisan key:generate --force 2>/dev/null || true

# Configure PHP
RUN echo "upload_max_filesize = 100M" > /usr/local/etc/php/conf.d/laravel.ini && \
    echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/laravel.ini && \
    echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/laravel.ini && \
    echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/laravel.ini && \
    echo "date.timezone = America/Sao_Paulo" >> /usr/local/etc/php/conf.d/laravel.ini

# Configure PHP-FPM
RUN echo "[global]" > /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "daemonize = no" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "[www]" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "listen = 127.0.0.1:9000" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "pm = dynamic" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "pm.max_children = 5" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "pm.start_servers = 2" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "pm.min_spare_servers = 1" >> /usr/local/etc/php-fpm.d/zzz-docker.conf && \
    echo "pm.max_spare_servers = 3" >> /usr/local/etc/php-fpm.d/zzz-docker.conf

# Configure Nginx
RUN mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled && \
    echo "user www-data;" > /etc/nginx/nginx.conf && \
    echo "worker_processes auto;" >> /etc/nginx/nginx.conf && \
    echo "error_log /var/log/nginx/error.log warn;" >> /etc/nginx/nginx.conf && \
    echo "pid /var/run/nginx.pid;" >> /etc/nginx/nginx.conf && \
    echo "" >> /etc/nginx/nginx.conf && \
    echo "events { worker_connections 1024; }" >> /etc/nginx/nginx.conf && \
    echo "" >> /etc/nginx/nginx.conf && \
    echo "http {" >> /etc/nginx/nginx.conf && \
    echo "  include /etc/nginx/mime.types;" >> /etc/nginx/nginx.conf && \
    echo "  default_type application/octet-stream;" >> /etc/nginx/nginx.conf && \
    echo "  sendfile on;" >> /etc/nginx/nginx.conf && \
    echo "  keepalive_timeout 65;" >> /etc/nginx/nginx.conf && \
    echo "  client_max_body_size 100M;" >> /etc/nginx/nginx.conf && \
    echo "  gzip on;" >> /etc/nginx/nginx.conf && \
    echo "" >> /etc/nginx/nginx.conf && \
    echo "  server {" >> /etc/nginx/nginx.conf && \
    echo "    listen 80;" >> /etc/nginx/nginx.conf && \
    echo "    root /app/public;" >> /etc/nginx/nginx.conf && \
    echo "    index index.php;" >> /etc/nginx/nginx.conf && \
    echo "" >> /etc/nginx/nginx.conf && \
    echo "    location / {" >> /etc/nginx/nginx.conf && \
    echo "      try_files \$uri \$uri/ /index.php?\$query_string;" >> /etc/nginx/nginx.conf && \
    echo "    }" >> /etc/nginx/nginx.conf && \
    echo "" >> /etc/nginx/nginx.conf && \
    echo "    location ~ \\.php\$ {" >> /etc/nginx/nginx.conf && \
    echo "      fastcgi_pass 127.0.0.1:9000;" >> /etc/nginx/nginx.conf && \
    echo "      fastcgi_index index.php;" >> /etc/nginx/nginx.conf && \
    echo "      include fastcgi_params;" >> /etc/nginx/nginx.conf && \
    echo "      fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/nginx.conf && \
    echo "    }" >> /etc/nginx/nginx.conf && \
    echo "  }" >> /etc/nginx/nginx.conf && \
    echo "}" >> /etc/nginx/nginx.conf

# Configure Supervisor
RUN mkdir -p /var/log/supervisor && \
    echo "[supervisord]" > /etc/supervisor/conf.d/laravel.conf && \
    echo "nodaemon=true" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "[program:php-fpm]" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "command=/usr/local/sbin/php-fpm" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "autostart=true" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "stderr_logfile=/var/log/supervisor/php-fpm.err.log" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "stdout_logfile=/var/log/supervisor/php-fpm.out.log" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "[program:nginx]" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "command=/usr/sbin/nginx -g 'daemon off;'" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "autostart=true" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "autorestart=true" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "stderr_logfile=/var/log/supervisor/nginx.err.log" >> /etc/supervisor/conf.d/laravel.conf && \
    echo "stdout_logfile=/var/log/supervisor/nginx.out.log" >> /etc/supervisor/conf.d/laravel.conf

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/ || exit 1

# Start supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
