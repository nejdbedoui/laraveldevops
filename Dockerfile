# Use the official PHP image as a base
FROM php:8.1-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip pdo pdo_mysql

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install Node.js (for asset compilation)
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Copy the existing application directory contents
COPY . .

# Install Composer dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Install Node.js dependencies
RUN npm install

# Build assets
RUN npm run build

# Expose the port the app runs on
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
