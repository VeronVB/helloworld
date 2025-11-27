🚀 Ultra-Light Nginx + PHP-FPM (Alpine)

Minimalistyczny, zoptymalizowany obraz Docker łączący Nginx oraz PHP-FPM 8.3 w jednym kontenerze. Zbudowany na bazie Alpine Linux.

Zaprojektowany z myślą o maksymalnej wydajności i minimalnym rozmiarze. Idealny do prostych stron, wizytówek i mikroserwisów PHP.

✨ Kluczowe cechy

    Ultra-lekki: Rozmiar obrazu zredukowany do minimum (~20-30MB).

    Single-Container Architecture: Nginx i PHP działają w jednym kontenerze bez ciężkiego supervisord. Procesami zarządza lekki, customowy entrypoint.sh.

    Smart Permissions: Skrypt startowy automatycznie naprawia uprawnienia (chown/chmod) rekursywnie dla całego katalogu /www. Ułatwia to pracę z PHP, które od razu ma prawo zapisu w katalogu głównym.

    Docker Friendly Logs: Logi Nginx i PHP są przekierowane do stdout/stderr.

    Security: Nginx działa jako non-root user.

📦 Struktura katalogów

    /www - Główny katalog aplikacji (web root). To tutaj ląduje Twój kod. Użytkownik nginx posiada pełne prawa zapisu w tym katalogu.

🚀 Szybki start

Docker CLI

Uruchomienie kontenera:

<pre id="bkmrk-%C2%A0-services%3A-%C2%A0-%C2%A0-web%3A-1"><code class="language-yaml">&nbsp; services:
&nbsp; &nbsp; web:
&nbsp; &nbsp; &nbsp; image: veronvb/helloworld:latest
&nbsp; &nbsp; &nbsp; restart: unless-stopped
&nbsp; &nbsp; &nbsp; ports:
&nbsp; &nbsp; &nbsp; &nbsp; - "80:80"
&nbsp; &nbsp; &nbsp; volumes:
&nbsp; &nbsp; &nbsp; &nbsp; # Montujemy tylko plik licznika, reszta kodu zostaje z obrazu
&nbsp; &nbsp; &nbsp; &nbsp; # Uwaga: plik licznik.txt musi istnieć na hoście (może być pusty)
&nbsp; &nbsp; &nbsp; &nbsp; - ./data/licznik.txt:/www/licznik.txt</code></pre>

Twoja strona będzie dostępna pod adresem: http://localhost:8080

Docker Compose

Poniżej przykład konfiguracji.

⚠️ WAŻNE: Ponieważ obraz zawiera już kod aplikacji w /www, podmontowanie całego folderu z hosta (./data:/www) przykryje pliki znajdujące się w obrazie.

Zalecane podejście zależy od Twojego celu:

Opcja A: Developement (Chcę edytować kod na żywo)

Podmontuj swój lokalny folder z kodem do kontenera:

  services:
    web:
      image: veronvb/helloworld:latest
      ports:
        - "80:80"
      volumes:
        - ./src:/www # Twój lokalny kod zastąpi ten w obrazie
        
Opcja B: Produkcja (Kod jest w obrazie, chcę zachować tylko licznik/dane)

Jeśli kod jest "wypieczony" w obrazie, montuj tylko konkretne pliki danych lub podkatalogi, aby nie ukryć kodu aplikacji:

  services:
    web:
      image: veronvb/helloworld:latest
      restart: unless-stopped
      ports:
        - "80:80"
      volumes:
        # Montujemy tylko plik licznika, reszta kodu zostaje z obrazu
        # Uwaga: plik licznik.txt musi istnieć na hoście (może być pusty)
        - ./data/licznik.txt:/www/licznik.txt

⚙️ Zaawansowane

Entrypoint i Sygnały

Obraz wykorzystuje komendę exec do uruchomienia procesu Nginx. Oznacza to, że kontener poprawnie obsługuje sygnały systemowe (np. SIGTERM, SIGINT), co pozwala na szybkie i bezpieczne zatrzymywanie kontenera.

Konfiguracja PHP

PHP-FPM nasłuchuje na 127.0.0.1:9000 i działa jako użytkownik nginx. Logi błędów PHP trafiają na standardowe wyjście błędów (stderr).
