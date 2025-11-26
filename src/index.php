<?php
// --- LOGIKA LICZNIKA (SERVER-SIDE) ---
$counterFile = 'licznik.txt';

// Jeśli plik nie istnieje, utwórz go z wartością 0
if (!file_exists($counterFile)) {
    file_put_contents($counterFile, 0);
}

// Pobierz obecną liczbę, zwiększ i zapisz
$visits = (int)file_get_contents($counterFile);
$visits++;
file_put_contents($counterFile, $visits);
?>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="author" content="Michał Nowak">
    <meta name="description" content="Strona główna">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="icon" type="image/svg+xml" href="favicon.svg">
    <title>twoja-domena.pl - Strona Główna</title>

    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

    <style>
        :root {
            --main-blue: #34495e;
            --hover-blue: #2c3e50;
            --text-color: #ecf0f1;
        }
        html, body { height: 100%; margin: 0; }
        body { display: flex; flex-direction: column; background-color: #f5f5f5; }
        .content-wrapper { flex: 1 0 auto; padding-top: 70px; }
        
        .navbar-custom { background-color: var(--main-blue); border-color: var(--hover-blue); }
        .navbar-custom .navbar-brand, .navbar-custom .navbar-nav > li > a { color: var(--text-color); }
        .navbar-custom .navbar-nav > .active > a, 
        .navbar-custom .navbar-nav > .active > a:hover { background-color: var(--hover-blue); color: #fff; }
        .navbar-custom .navbar-nav > li > a:hover { color: #fff; background-color: transparent; }

        .navbar-brand { transition: all 0.3s ease; font-weight: bold; }
        .navbar-brand:hover { text-shadow: 0 0 10px rgba(255, 255, 255, 0.7); transform: scale(1.05); color: #fff !important; }

        .footer { flex-shrink: 0; background-color: var(--main-blue); color: var(--text-color); padding: 20px 0; text-align: center; width: 100%; margin-top: 20px; }
        .footer p { margin: 0; font-size: 14px; }
        #clock, #visits { font-weight: bold; color: #fff; }
    </style>

    <script type="text/javascript">
        function padZero(num) { return num < 10 ? "0" + num : num; }

        function updateClock() {
            var currentTime = new Date();
            var currentTimeString = padZero(currentTime.getHours()) + ":" + 
                                    padZero(currentTime.getMinutes()) + ":" + 
                                    padZero(currentTime.getSeconds());
            document.getElementById("clock").innerText = currentTimeString;
        }

        window.onload = function() {
            updateClock();
            setInterval(updateClock, 1000);
        };
    </script>
</head>
<body>

    <div class="content-wrapper">
        <nav class="navbar navbar-custom navbar-fixed-top">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar">
                        <span class="sr-only">Nawigacja</span>
                        <span class="icon-bar" style="background-color: white;"></span>
                        <span class="icon-bar" style="background-color: white;"></span>
                        <span class="icon-bar" style="background-color: white;"></span>
                    </button>
                    <a class="navbar-brand" href="/">twoja-domena.pl</a>
                </div>
                <div id="navbar" class="navbar-collapse collapse">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="/">Strona Główna</a></li>
                        <li><a href="#omnie">O mnie</a></li>
                        <li><a href="#kontakt">Kontakt</a></li>
                    </ul>
                </div>
            </div>
        </nav>

        <div class="container theme-showcase" role="main">
            <div class="jumbotron">
                <h1>Witaj</h1>
                <p>Czy to mnie szukasz?</p>
            </div>
        </div> 
    </div>

    <footer class="footer">
        <div class="container">
            <p>
                &copy; 2025 twoja-domena.pl &nbsp;|&nbsp; 
                Odwiedziny: <span id="visits"><?php echo $visits; ?></span> &nbsp;|&nbsp; 
                Czas: <span id="clock">...</span>
            </p>
        </div>
    </footer>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</body>
</html>
