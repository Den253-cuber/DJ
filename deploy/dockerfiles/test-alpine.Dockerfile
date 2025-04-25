FROM php:8.4.6-fpm-alpine3.20

WORKDIR "/var/www/dj"

ARG WWWGROUP
ARG WWWUSER

USER root

RUN apk update && apk add --no-cache \
    autoconf \
    linux-headers \
    gcc \
    sockets \
    g++ \
    git \
    make \
    libzip-dev \
    postgresql-dev \
    icu-dev \
    zip \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    jpeg-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg

RUN docker-php-ext-install \
        pdo_pgsql \
        pgsql \
        mysqli \
        pdo_mysql \
        zip \
        exif \
        intl \
        gd \
        pcntl \
    && pecl update-channels \
    && pecl install -o -f redis \
    && docker-php-ext-enable \
        redis \
        pcntl \
    && rm -rf /tmp/pear

RUN addgroup -g $WWWGROUP www && \
    adduser -u $WWWUSER -G www -s /bin/sh -D www

USER www
