FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Create directory for the socket
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Copy the setup script and config
COPY ./tools/mariadb.sh /usr/local/bin/
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/

RUN chmod +x /usr/local/bin/mariadb.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
