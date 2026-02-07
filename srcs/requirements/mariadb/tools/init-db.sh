#!/bin/sh
set -e

# Read secrets
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # Start MariaDB temporarily for setup
    mysqld --user=mysql --datadir=/var/lib/mysql &
    pid=$!

    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    while ! mysqladmin ping --silent 2>/dev/null; do
        sleep 1
    done

    echo "Creating database and users..."
    
    # Setup database and users
    mysql -u root <<EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- Create WordPress database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create WordPress user with password from secrets
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Flush privileges
FLUSH PRIVILEGES;
EOF

    echo "Database initialization complete!"
    
    # Stop temporary MariaDB
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
    wait $pid
fi

echo "Starting MariaDB..."
# Run MariaDB in foreground (PID 1)
exec mysqld --user=mysql
