#!/bin/sh
set -e

# Read secrets
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

FIRST_RUN=0

# Initialize database if not exists
if [ ! -d "/var/lib/mysql/mysql" ]; then
    FIRST_RUN=1
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily for setup
mysqld --user=mysql --datadir=/var/lib/mysql --skip-grant-tables &
pid=$!

# Wait for MariaDB to start
echo "Waiting for MariaDB to start..."
while ! mariadb-admin ping --silent 2>/dev/null; do
    sleep 1
done

if [ "$FIRST_RUN" = "1" ]; then
    echo "First run - creating database and users..."
    
    mariadb -u root <<EOF
FLUSH PRIVILEGES;

-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';

-- Remove remote root access
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';

-- Create WordPress database
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

-- Create WordPress user with password from secrets
DROP USER IF EXISTS '${MYSQL_USER}'@'%';
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    echo "Database initialization complete!"
fi

# Stop temporary MariaDB
mariadb-admin -u root shutdown 2>/dev/null || mariadb-admin shutdown 2>/dev/null || kill $pid
wait $pid 2>/dev/null

echo "Starting MariaDB..."
# Run MariaDB in foreground (PID 1)
exec mysqld --user=mysql
