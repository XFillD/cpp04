FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wget \
    php7.4 \
    php7.4-fpm \
    php7.4-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Inject the PHP-FPM pool config and the WordPress setup script
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/
COPY ./tools/create_wordpress.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/create_wordpress.sh

# Make sure the PHP-FPM runtime directory is present
RUN mkdir -p /run/php

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/create_wordpress.sh"]
