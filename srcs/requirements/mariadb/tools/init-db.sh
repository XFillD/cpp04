#!/bin/sh

# Read secrets
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize database if data directory is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily (fresh install allows root without password)
    mysqld --user=mysql &
    pid=$!

    echo "Waiting for MariaDB to start..."
    sleep 5
    while ! mariadb -u root -e "SELECT 1" 2>/dev/null; do
        sleep 2
    done

    echo "Creating database and users..."

    mariadb -u root <<EOF
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Database initialization complete!"

    # Stop temporary MariaDB
    kill $pid
    wait $pid 2>/dev/null
fi

echo "Starting MariaDB..."
# Run MariaDB in foreground (PID 1)
exec mysqld --user=mysql
