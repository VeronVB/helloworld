FROM alpine:latest

# Instalacja Nginx i PHP-FPM
# --no-cache: Nie zapisuje cache'u pakietów na dysku (oszczędność miejsca)
RUN apk add --no-cache \
    nginx \
    php83 \
    php83-fpm \
    # Opcjonalnie: php83-ctype php83-session itp. jeśli skrypt tego wymaga
    && mkdir -p /run/nginx /www \
    # Przekierowanie logów Nginx do stdout/stderr (dla `docker logs`)
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    # Konfiguracja PHP-FPM, aby działał jako użytkownik 'nginx' (domyślnie jest 'nobody')
    && sed -i 's/user = nobody/user = nginx/g' /etc/php83/php-fpm.d/www.conf \
    && sed -i 's/group = nobody/group = nginx/g' /etc/php83/php-fpm.d/www.conf \
    # Upewnienie się, że PHP loguje błędy do stderr
    && sed -i 's/;catch_workers_output = yes/catch_workers_output = yes/g' /etc/php83/php-fpm.d/www.conf

# Kopiowanie konfiguracji i skryptów
COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /entrypoint.sh

# Kopiowanie aplikacji (jeśli masz kod źródłowy w folderze src)
# Jeśli nie, możesz to pominąć i montować kod przez wolumen
COPY ./src /www

# Nadanie uprawnień wykonywalnych dla entrypointa
RUN chmod +x /entrypoint.sh

# Port
EXPOSE 80

# Uruchomienie
ENTRYPOINT ["/entrypoint.sh"]
