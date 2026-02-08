# Developer Documentation

## 1. Prerequisites
To develop or maintain this project, the host machine must have:
* **Docker Engine** (installed and running).
* **Docker Compose** (Plugin V2 recommended).
* **Make**.
* **Sudo privileges** (to manage `/etc/hosts` and data folders).

## 2. Setup & Installation
1.  **Domain Mapping:**
    Add the following line to your `/etc/hosts` file to redirect the domain to your local machine:
    ```text
    127.0.0.1  fhauba.42.fr
    ```
2.  **Environment Variables:**
    A `.env` file must be present in `srcs/.env`. It configures sensitive data for the build process.
    *Template:*
    ```ini
    DOMAIN_NAME=fhauba.42.fr
    MYSQL_DATABASE=wordpress
    MYSQL_USER=...
    MYSQL_PASSWORD=...
    ```

## 3. Build Architecture
The project is orchestrated via `srcs/docker-compose.yml`.
* **Images:** We build custom images from `debian:bullseye`.
* **Dependencies:** `wordpress` depends on `mariadb`; `nginx` depends on `wordpress`.

### Directory Structure
* `srcs/requirements/mariadb`: Dockerfile & scripts for the Database.
* `srcs/requirements/wordpress`: Dockerfile & PHP-FPM config.
* `srcs/requirements/nginx`: Dockerfile & SSL generation.

## 4. Data Persistence
Data is not stored inside the containers. It uses **Docker Volumes** mapped to the host machine to ensure persistence across restarts.

* **Host Location:** `/home/fhauba/data/`
    * **Database Files:** `/home/fhauba/data/mariadb`
    * **Website Files:** `/home/fhauba/data/wordpress`

## 5. Common Commands
* **Build and start in background:**
    ```bash
    docker compose -f srcs/docker-compose.yml up -d --build
    ```
* **View Logs (Debugging):**
    ```bash
    docker logs wordpress
    docker logs nginx
    docker logs mariadb
    ```
* **Enter a container shell:**
    ```bash
    docker exec -it wordpress bash
    ```
