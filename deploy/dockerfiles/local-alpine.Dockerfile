FROM php:8.4-fpm-alpine3.20

WORKDIR "/var/www/dj"

ARG WWWGROUP
ARG WWWUSER

USER root

RUN apk update && apk add --no-cache \
    zlib-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    autoconf \
    linux-headers \
    gcc \
    g++ \
    git \
    make \
    postgresql-dev \
    icu-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg

RUN docker-php-ext-install \
    pdo_pgsql \
    pgsql \
    intl \
    && pecl update-channels \
    && pecl install -o -f redis \
    && docker-php-ext-enable \
        redis \
    && rm -rf /tmp/pear

RUN addgroup -g $WWWGROUP www && \
    adduser -u $WWWUSER -G www -s /bin/sh -D www

USER www
