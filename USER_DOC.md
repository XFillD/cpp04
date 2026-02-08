# User Guide

## 1. What This Is
A self-hosted **WordPress** website running inside Docker containers.
* **Web access** is served over HTTPS.
* **All content** is stored in a MariaDB database.
* **TLS encryption** is handled by an NGINX reverse proxy.

## 2. Controlling the Stack
Use the `Makefile` in the project root to manage everything:

* **Bring the site up:**
    ```bash
    make
    ```
    *Builds every container from scratch (if needed) and starts the services.*

* **Shut it down:**
    ```bash
    make down
    ```
    *Stops all running containers gracefully.*

* **Full wipe (destructive):**
    ```bash
    make fclean
    ```
    *Removes containers, images, **and all stored data** — use with caution.*

## 3. Opening the Website
After `make` finishes:
1.  Launch any modern browser (Firefox, Chrome, etc.).
2.  Go to **[https://fhauba.42.fr](https://fhauba.42.fr)**
3.  The browser will warn about an untrusted certificate (it is self-signed). Accept the exception to continue.

## 4. Login Details
WordPress admin panel lives at `/wp-admin`. All credentials are defined in `srcs/.env`:

* **Admin username:** value of `WP_ADMIN_USER`
* **Admin password:** value of `WP_ADMIN_PASSWORD`
* **DB user:** value of `MYSQL_USER`

## 5. Health Check
Run this to confirm all three containers are up:
```bash
docker ps
