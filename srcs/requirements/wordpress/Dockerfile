# ============================================
# WordPress + PHP-FPM Container (NO NGINX)
# ============================================
FROM debian:bookworm

# Install PHP-FPM and required extensions for WordPress
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-xml \
    php8.2-zip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Download WP-CLI for WordPress installation
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on port 9000
RUN sed -i 's|listen = /run/php/php8.2-fpm.sock|listen = 9000|g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|;listen.owner = www-data|listen.owner = www-data|g' /etc/php/8.2/fpm/pool.d/www.conf && \
    sed -i 's|;listen.group = www-data|listen.group = www-data|g' /etc/php/8.2/fpm/pool.d/www.conf

# Create directory for PHP-FPM pid file
RUN mkdir -p /run/php && chown www-data:www-data /run/php

# Create web root directory
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Copy setup script
COPY tools/setup-wordpress.sh /usr/local/bin/setup-wordpress.sh
RUN chmod +x /usr/local/bin/setup-wordpress.sh

# Copy PHP-FPM configuration
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

WORKDIR /var/www/html

EXPOSE 9000

# Run WordPress setup then PHP-FPM (PID 1 best practice)
ENTRYPOINT ["/usr/local/bin/setup-wordpress.sh"]
