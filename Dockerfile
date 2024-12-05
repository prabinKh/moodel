FROM php:8.1-fpm

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libicu-dev \
    libpq-dev \
    git \
    zip \
    unzip

# Configure and install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    intl \
    zip \
    soap \
    opcache \
    pdo_mysql \
    mysqli \
    pdo_pgsql \
    gd \
    exif

WORKDIR /var/www/html

# Download and install Moodle
RUN git clone -b MOODLE_402_STABLE git://git.moodle.org/moodle.git . \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create moodledata directory with proper permissions
RUN mkdir -p /var/www/moodledata \
    && chown -R www-data:www-data /var/www/moodledata \
    && chmod -R 777 /var/www/moodledata

USER www-data
