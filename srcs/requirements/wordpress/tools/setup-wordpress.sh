#!/bin/sh
set -e

# Read secrets
DB_PASSWORD=$(cat /run/secrets/db_password)

# Parse credentials file
CREDS_FILE="/run/secrets/credentials"
WP_ADMIN_USER=$(grep "WP_ADMIN_USER" "$CREDS_FILE" | cut -d'=' -f2)
WP_ADMIN_PASSWORD=$(grep "WP_ADMIN_PASSWORD" "$CREDS_FILE" | cut -d'=' -f2)
WP_ADMIN_EMAIL=$(grep "WP_ADMIN_EMAIL" "$CREDS_FILE" | cut -d'=' -f2)
WP_USER=$(grep "WP_USER=" "$CREDS_FILE" | cut -d'=' -f2)
WP_USER_PASSWORD=$(grep "WP_USER_PASSWORD" "$CREDS_FILE" | cut -d'=' -f2)
WP_USER_EMAIL=$(grep "WP_USER_EMAIL" "$CREDS_FILE" | cut -d'=' -f2)

cd /var/www/html

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
while ! mysqladmin ping -h"${MYSQL_HOST}" --silent 2>/dev/null; do
    sleep 2
done
echo "MariaDB is ready!"

# Check if WordPress is already installed
if [ ! -f "/var/www/html/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost="${MYSQL_HOST}" \
        --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="${WP_URL}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "Creating additional user..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root

    # Set proper permissions
    chown -R www-data:www-data /var/www/html
    chmod -R 755 /var/www/html

    echo "WordPress installation complete!"
else
    echo "WordPress already installed, skipping setup."
fi

echo "Starting PHP-FPM..."
# Run PHP-FPM in foreground (PID 1)
exec php-fpm7.4 -F
