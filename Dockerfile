FROM php:8.2

# Update and install necessary packages
RUN apt-get update -y && apt-get install -y \
    openssl zip unzip git \
    libonig-dev default-mysql-client

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring

# Set working directory
WORKDIR /app
COPY . /app

# Install PHP dependencies via Composer
RUN composer install

# Command to run your application
CMD php artisan serve --host=0.0.0.0 --port=8181

# Expose the port for the application
EXPOSE 8181
