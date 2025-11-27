FROM alpine:latest

# Install Nginx and PHP-FPM
# --no-cache: Do not cache the package index locally (saves space)
RUN apk add --no-cache \
    nginx \
    php83 \
    php83-fpm \
    # Optional: php83-ctype php83-session etc., if required by your script
    && mkdir -p /run/nginx /www \
    # Forward Nginx logs to stdout/stderr (for `docker logs`)
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Configure PHP-FPM to run as user 'nginx' (default is 'nobody')
    && sed -i 's/user = nobody/user = nginx/g' /etc/php83/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = nginx/g' /etc/php83/php-fpm.d/www.conf \
    # Ensure PHP logs errors to stderr
    && sed -i 's/;catch_workers_output = yes/catch_workers_output = yes/g' /etc/php83/php-fpm.d/www.conf

# Copy configuration and scripts
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Copy application (if you have source code in the src folder)
# If not, you can skip this and mount code via a volume
COPY ./src /www

# Make entrypoint executable
RUN chmod +x /entrypoint.sh

# Port
EXPOSE 80

# Start
ENTRYPOINT ["/entrypoint.sh"]
