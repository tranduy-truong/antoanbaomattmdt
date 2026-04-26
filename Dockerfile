# Nền tảng PHP 8.2 và Apache
FROM php:8.2-apache

# Cài đặt các thư viện lõi của Linux và PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev zip unzip git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql

# Bật tính năng định tuyến của Apache (mod_rewrite)
RUN a2enmod rewrite

# Chuyển vào thư mục làm việc
WORKDIR /var/www/html
COPY . .

# Cài đặt Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --no-scripts --no-autoloader

# Cấp quyền cho thư mục sinh file tạm của Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Trỏ máy chủ web thẳng vào thư mục /public
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80