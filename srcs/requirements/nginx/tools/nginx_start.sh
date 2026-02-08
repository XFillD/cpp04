#!/bin/bash

# Generate a self-signed certificate on first run if none is present
if [ ! -f /etc/nginx/ssl/inception.crt ]; then
    echo "Setting up SSL..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=CZ/ST=Prague/L=Prague/O=42/OU=42/CN=fhauba.42.fr/UID=fhauba"
fi

# Launch Nginx as the main process (non-daemon mode)
echo "Starting Nginx..."
exec nginx -g 'daemon off;'
