FROM  php:7.4.7-fpm-alpine3.12
LABEL maintainer="Pedro Rodrigues <pir.pedro@gmail.com>"

RUN apk add --no-cache --virtual \
    openssl bash mysql-client nodejs npm sudo libzip-dev

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

#ext-zip is necessary only for laravel installation
RUN docker-php-ext-install pdo pdo_mysql bcmath \ 
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

RUN addgroup -g 1000 -S app && adduser -u 1000 -S app -G app -s /bin/bash \
    && adduser app wheel \
    && sed -e 's;^# \(%wheel.*NOPASSWD.*\);\1;g' -i /etc/sudoers \
    && mkdir -p /usr/src/app \
    && chown -R app:app /usr/src \
    && chmod -R 777 /usr/src/app


WORKDIR /var/www
RUN rm -rf html \
    && ln -s /usr/src/app/public public \
    && chown -R www-data:www-data /var/www/*

USER app
WORKDIR /usr/src/app

EXPOSE 9000
ENTRYPOINT ["php-fpm"]

