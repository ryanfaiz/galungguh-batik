# Use the official PHP image with PHP 8.3.6
FROM php:8.3.6-fpm

# Set working directory inside the container
WORKDIR /var/www

# Install system dependencies (e.g., for Composer, Laravel, and PHP extensions)
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    zip \
    git \
    unzip \
    curl \
    libpq-dev

# Install PHP extensions required for Laravel (e.g., pdo, pdo_mysql, gd)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install intl zip gd pdo pdo_mysql

# Install Composer globally (v2.8.8)
RUN curl -sS https://getcomposer.org/installer | php -- --version=2.8.8 --install-dir=/usr/local/bin --filename=composer

# Copy the existing Laravel project to the container's working directory
COPY . .

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose port 9000 (PHP-FPM default)
EXPOSE 9000

# Set the entry point to start PHP-FPM (the default for PHP 8.3.6 image)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]