# ---------- Stage 1: install vendor tanpa menjalankan skrip artisan ----------
FROM composer:2 AS vendor
WORKDIR /app

# Supaya Composer boleh jalan sebagai root di container
ENV COMPOSER_ALLOW_SUPERUSER=1

# Salin file kunci dependensi
COPY composer.json composer.lock ./

# Install ALL dependencies including dev (needed for Pail)
RUN composer install --prefer-dist --no-progress --no-interaction --no-scripts

# ---------- Stage 2: image aplikasi (PHP-FPM) ----------
FROM php:8.2-fpm AS app
WORKDIR /var/www/html

# Ekstensi umum Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev libpng-dev libonig-dev libxml2-dev unzip git curl \
 && docker-php-ext-install pdo_mysql zip \
 && apt-get clean && rm -rf /var/lib/apt/lists/*

# Salin seluruh source code Laravel
COPY . /var/www/html

# Salin folder vendor dari stage pertama
COPY --from=vendor /app/vendor /var/www/html/vendor

# Permission agar storage & cache bisa ditulis
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# (Opsional) Setelah source & vendor lengkap, jalankan skrip yang tadinya di-skip.
# Tidak wajib waktu build; bisa dilakukan saat container berjalan.
# RUN php artisan package:discover --ansi || true

EXPOSE 9000
CMD ["php-fpm"]
