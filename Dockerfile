# Multi-stage build
FROM php:8.2-fpm-alpine AS builder

WORKDIR /app

# Instalar dependências do sistema
RUN apk add --no-cache \
    curl \
    git \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    zip \
    unzip

# Instalar extensões PHP
RUN docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_sqlite \
    pdo_mysql \
    openssl \
    mbstring \
    json \
    fileinfo \
    curl \
    zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copiar arquivos
COPY . .

# Instalar dependências PHP
RUN composer install --no-interaction --optimize-autoloader

# Gerar chave da aplicação
RUN php artisan key:generate || true

# Runtime stage
FROM php:8.2-fpm-alpine

WORKDIR /app

# Instalar runtime deps
RUN apk add --no-cache \
    libpng \
    libjpeg-turbo \
    freetype \
    nginx \
    supervisor

# Copiar extensões PHP
COPY --from=php:8.2-fpm-alpine /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=php:8.2-fpm-alpine /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

# Instalar extensões
RUN docker-php-ext-install -j$(nproc) \
    gd \
    pdo \
    pdo_sqlite \
    pdo_mysql \
    openssl \
    mbstring \
    json \
    fileinfo \
    curl \
    zip

# Copiar aplicação
COPY --from=builder /app /app

# Copiar configurações
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/php.ini /usr/local/etc/php/conf.d/laravel.ini

# Criar diretórios necessários
RUN mkdir -p /app/storage/logs && \
    chmod -R 777 /app/storage && \
    chmod -R 777 /app/bootstrap/cache

# Expor portas
EXPOSE 80 9000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD php artisan tinker --execute="echo 'OK'" || exit 1

# Comando inicial
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
