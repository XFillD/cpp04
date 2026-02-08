FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Ensure the folder for TLS key and certificate exists
RUN mkdir -p /etc/nginx/ssl

# Place the virtual-host config and the launcher script
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./tools/nginx_start.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/nginx_start.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/nginx_start.sh"]
