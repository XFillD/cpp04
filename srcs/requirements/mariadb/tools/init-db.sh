#!/bin/sh

# Read secrets
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
DB_PASSWORD=$(cat /run/secrets/db_password)

# Initialize database if data directory is empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    # Write init SQL to temp file
    cat > /tmp/init.sql <<EOF
FLUSH PRIVILEGES;
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "Running first-time database setup..."
    # Start MariaDB with init-file (executes SQL on startup)
    mysqld --user=mysql --init-file=/tmp/init.sql &
    pid=$!

    # Wait until ready
    sleep 5
    while ! mariadb-admin ping -u root -p"${DB_ROOT_PASSWORD}" --silent 2>/dev/null; do
        sleep 2
    done

    echo "Database initialization complete!"

    # Clean up and stop
    rm -f /tmp/init.sql
    kill $pid
    wait $pid 2>/dev/null
fi

echo "Starting MariaDB..."
# Run MariaDB in foreground (PID 1)
exec mysqld --user=mysql
