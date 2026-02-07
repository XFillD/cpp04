# ============================================
# MariaDB Container - Database Only
# ============================================
FROM debian:bullseye

# Install MariaDB server
RUN apt-get update && apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Create necessary directories
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 755 /var/run/mysqld

# Copy initialization script
COPY tools/init-db.sh /usr/local/bin/init-db.sh
RUN chmod +x /usr/local/bin/init-db.sh

# Copy custom configuration
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Expose MySQL port
EXPOSE 3306

# Run init script then MariaDB (PID 1 best practice)
ENTRYPOINT ["/usr/local/bin/init-db.sh"]
