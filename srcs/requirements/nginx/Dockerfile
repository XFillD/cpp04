# ============================================
# NGINX Container - TLSv1.2/1.3 Only
# ============================================
FROM debian:bookworm

# Install nginx and openssl for TLS
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=CZ/ST=Prague/L=Prague/O=42/OU=42Prague/CN=fhauba.42.fr"

# Copy nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Create www-data user directory
RUN mkdir -p /var/www/html && chown -R www-data:www-data /var/www/html

# Expose HTTPS port only
EXPOSE 443

# Run nginx in foreground (PID 1 best practice)
CMD ["nginx", "-g", "daemon off;"]
