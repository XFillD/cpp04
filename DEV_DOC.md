# Developer Guide

## 1. Requirements
Before working on this project make sure the host has:
* **Docker Engine** — up and running.
* **Docker Compose V2** (the `docker compose` plugin).
* **GNU Make**.
* **Root / sudo access** — needed for `/etc/hosts` edits and data-directory permissions.

## 2. Initial Setup
1.  **Local DNS:**
    Point the project domain to localhost by appending this line to `/etc/hosts`:
    ```text
    127.0.0.1  fhauba.42.fr
    ```
2.  **Credentials file:**
    Create (or verify) `srcs/.env` with at least the following keys:
    ```ini
    DOMAIN_NAME=fhauba.42.fr
    MYSQL_DATABASE=wordpress
    MYSQL_USER=...
    MYSQL_PASSWORD=...
    ```

## 3. How the Build Works
Everything is driven by `srcs/docker-compose.yml`.
* **Base image:** All containers derive from `debian:bullseye`.
* **Startup order:** `mariadb` → `wordpress` → `nginx` (enforced via `depends_on`).

### Source Layout
* `srcs/requirements/mariadb` — database image, init script, server config.
* `srcs/requirements/wordpress` — PHP-FPM image, WP-CLI installer, pool config.
* `srcs/requirements/nginx` — web-server image, TLS generator, virtual-host config.

## 4. Where Data Lives
Nothing persistent is kept inside a container. Named Docker volumes bind to host directories so data survives rebuilds.

* **Root path:** `/home/fhauba/data/`
    * **MariaDB tables:** `/home/fhauba/data/mariadb`
    * **WordPress files:** `/home/fhauba/data/wordpress`

## 5. Useful Commands
* **Rebuild and launch (detached):**
    ```bash
    docker compose -f srcs/docker-compose.yml up -d --build
    ```
* **Inspect container output:**
    ```bash
    docker logs wordpress
    docker logs nginx
    docker logs mariadb
    ```
* **Drop into a running container:**
    ```bash
    docker exec -it wordpress bash
    ```
