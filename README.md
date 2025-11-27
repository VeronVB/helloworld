🚀 Ultra-Light Nginx + PHP-FPM (Alpine)

A minimalist, optimized Docker image combining Nginx and PHP-FPM 8.3 in a single container. Built on Alpine Linux.

Designed for maximum performance and minimum size. Ideal for simple websites, landing pages, and PHP microservices.

✨ Key Features

    Ultra-light: Image size reduced to the minimum (~20-30MB).

    Single-Container Architecture: Nginx and PHP run in one container without a heavy supervisord. Processes are managed by a lightweight, custom entrypoint.sh.

    Smart Permissions: The startup script automatically fixes permissions (chown/chmod) recursively for the entire /www directory. This simplifies PHP workflows, granting immediate write access to the web root.

    Docker Friendly Logs: Nginx and PHP logs are redirected to stdout/stderr.

    Security: Nginx runs as a non-root user.

📦 Directory Structure

    /www - Main application directory (web root). Your code goes here. The nginx user has full write permissions in this directory.

🚀 Quick Start

Docker CLI

Run the container:

<p id="bkmrk-%C2%A0"></p>
<pre id="bkmrk-docker-run--d--p-808"><code class="language-bash">docker run -d -p 8080:80 --name my-website veronvb/helloworld:latest</code></pre>
<p id="bkmrk-%C2%A0-1"></p>

Your website will be available at: http://localhost:8080

Docker Compose

Below is a configuration example.

⚠️ IMPORTANT: Since the image already contains application code in /www, mounting a host folder (e.g., ./data:/www) will overwrite/hide the files located in the image.

The recommended approach depends on your goal:

Option A: Development (I want to edit code live)

Mount your local code directory to the container:

<pre id="bkmrk-%C2%A0-services%3A-%C2%A0-%C2%A0-web%3A"><code class="language-yaml">&nbsp; services:
&nbsp; &nbsp; web:
&nbsp; &nbsp; &nbsp; image: veronvb/helloworld:latest
&nbsp; &nbsp; &nbsp; ports:
&nbsp; &nbsp; &nbsp; &nbsp; - "80:80"
&nbsp; &nbsp; &nbsp; volumes:
&nbsp; &nbsp; &nbsp; &nbsp; - ./src:/www # # Your local code replaces the one in the image </code></pre>
        
Option B: Production (Code is baked into the image, I only want to persist counter/data)

If the code is "baked" into the image, mount only specific data files or subdirectories to avoid hiding the application code:

<pre id="bkmrk-%C2%A0-services%3A-%C2%A0-%C2%A0-web%3A-1"><code class="language-yaml">&nbsp; services:
&nbsp; &nbsp; web:
&nbsp; &nbsp; &nbsp; image: veronvb/helloworld:latest
&nbsp; &nbsp; &nbsp; restart: unless-stopped
&nbsp; &nbsp; &nbsp; ports:
&nbsp; &nbsp; &nbsp; &nbsp; - "80:80"
&nbsp; &nbsp; &nbsp; volumes:
&nbsp; &nbsp; &nbsp; &nbsp; # We mount only the counter file, the rest of the code remains from the image
&nbsp; &nbsp; &nbsp; &nbsp; # Note: the file licznik.txt must exist on the host (can be empty)
&nbsp; &nbsp; &nbsp; &nbsp; - ./data/licznik.txt:/www/licznik.txt</code></pre>

⚙️ Advanced

Entrypoint and Signals

The image uses the exec command to start the Nginx process. This means the container correctly handles system signals (e.g., SIGTERM, SIGINT), allowing for quick and graceful container stops.

PHP Configuration

PHP-FPM listens on 127.0.0.1:9000 and runs as the nginx user. PHP error logs are sent to the standard error output (stderr).
