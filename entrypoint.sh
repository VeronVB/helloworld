#!/bin/sh

# 1. Naprawa uprawnień (Fix Permissions)
# Ponieważ /www/data jest montowane z hosta, UID/GID mogą się nie zgadzać.
# Wymuszamy własność dla użytkownika 'nginx' przy każdym starcie.
echo "Setting permissions for /www/data..."
chown -R nginx:nginx /www
chmod -R 755 /www

# 2. Start PHP-FPM w tle
# Używamy pełnej ścieżki do binarki (w Alpine może się różnić numerkiem, tu php-fpm83)
# -D wymusza tryb demona (tło), ale my wolimy uruchomić normalnie i wrzucić w tło przez '&'
# aby entrypoint żył dalej.
echo "Starting PHP-FPM..."
php-fpm83 -D

# Sprawdzamy czy PHP wstało (opcjonalne, ale dobre dla stabilności)
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start PHP-FPM: $status"
  exit $status
fi

# 3. Start Nginx na pierwszym planie (Foreground)
# To jest proces, który utrzymuje kontener przy życiu.
echo "Starting Nginx..."
nginx -g 'daemon off;'
