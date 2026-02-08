#!/bin/bash

# First-time setup: bootstrap the data directory if no system tables exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Starting MariaDB temporarily..."
    mysqld --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    # Poll until the server accepts connections
    echo "Waiting for MariaDB to be ready..."
    while ! mariadb -u root -e "SELECT 1" &>/dev/null; do
        sleep 1
    done
    echo "MariaDB is ready."

    # Provision the application database, user and root credentials
    mariadb -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "Database setup complete."

    # Gracefully stop the bootstrap server before launching for real
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$pid"
fi

# Run the database engine as PID 1 so the container stays alive
exec mysqld --user=mysql --datadir=/var/lib/mysql
