#!/bin/bash

cd /var/www/html

# Fetch the WP-CLI tool when it is not yet installed
if [ ! -f "/usr/local/bin/wp" ]; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Block until the database server is reachable
echo "Waiting for MariaDB to start..."
while ! mariadb -h$MYSQL_HOSTNAME -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE --silent; do
    echo "MariaDB is not ready yet. Waiting 5 seconds..."
    sleep 5
done
echo "MariaDB is connected!"

# Run the full WordPress setup only on the very first boot
if [ ! -f "wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating config..."
    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$MYSQL_HOSTNAME \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    echo "Creating user..."
    wp user create \
        $WP_USER \
        $WP_USER_EMAIL \
        --role=author \
        --user_pass=$WP_PASSWORD \
        --allow-root
fi

# Hand off to PHP-FPM as the foreground process
echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F
