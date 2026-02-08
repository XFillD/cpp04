#!/bin/bash

# Initialize the database if it doesn't exist
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    service mariadb start
    sleep 5

    # Secure installation and create database + user
    mariadb -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mariadb -u root -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    # Change root password and flush
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mariadb -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    # Shutdown to restart in safe mode
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

# Start MariaDB in safe mode (foreground)
exec mysqld_safe
