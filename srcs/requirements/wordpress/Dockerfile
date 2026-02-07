# ============================================
# WordPress + PHP-FPM Container (NO NGINX)
# ============================================
FROM debian:bullseye

# Install PHP-FPM and required extensions for WordPress
RUN apt-get update && apt-get install -y --no-install-recommends \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-intl \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-zip \
    php7.4-json \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Download WP-CLI for WordPress installation
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's|;listen.owner = www-data|listen.owner = www-data|g' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's|;listen.group = www-data|listen.group = www-data|g' /etc/php/7.4/fpm/pool.d/www.conf

# Create directory for PHP-FPM pid file
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Create web root directory
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Copy setup script
COPY tools/setup-wordpress.sh /usr/local/bin/setup-wordpress.sh
RUN chmod +x /usr/local/bin/setup-wordpress.sh

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

EXPOSE 9000

# Run WordPress setup then PHP-FPM (PID 1 best practice)
ENTRYPOINT ["/usr/local/bin/setup-wordpress.sh"]
