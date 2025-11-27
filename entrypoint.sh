#!/bin/sh

# 1. Fix Permissions
# Since /www/data is mounted from the host, UID/GID might not match.
# We enforce ownership for the 'nginx' user on every startup.
echo "Setting permissions for /www/data..."
chown -R nginx:nginx /www
chmod -R 755 /www

# 2. Start PHP-FPM in the background
# Using the full path to the binary (in Alpine, the version number might vary; here it is php-fpm83)
# -D forces daemon mode (background) so the script continues.
echo "Starting PHP-FPM..."
php-fpm83 -D

# Check if PHP started successfully (optional, but good for stability)
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start PHP-FPM: $status"
  exit $status
fi

# 3. Start Nginx in the foreground
# This is the process that keeps the container alive.
echo "Starting Nginx..."
nginx -g 'daemon off;'
