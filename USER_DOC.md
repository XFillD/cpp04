# User Documentation

## 1. Service Overview
This stack provides a fully functional **WordPress** blogging platform.
* **Website:** Accessible via HTTPS.
* **Database:** A MariaDB instance stores all site content safely.
* **Security:** An NGINX server handles SSL/TLS encryption.

## 2. Managing the Project
As a user, you can control the project using the provided `Makefile` at the root of the directory:

* **Start the Website:**
    ```bash
    make
    ```
    *This will download necessary components, build the containers, and launch the site.*

* **Stop the Website:**
    ```bash
    make down
    ```
    *This stops the running services.*

* **Clean Reset (Wipe Data):**
    ```bash
    make fclean
    ```
    *WARNING: This deletes the database and all website data.*

## 3. Accessing the Website
Once the command `make` has finished running:
1.  Open your web browser (Firefox/Chrome).
2.  Navigate to: **[https://jstudnic.42.fr](https://jstudnic.42.fr)**
3.  **Note:** You will see a "Security Warning" because we are using a self-signed certificate. You must accept the risk/advanced options to proceed.

## 4. Credentials
To log in to the WordPress Dashboard (`/wp-admin`) or manage the Database, refer to the **`.env`** file located in the `srcs/` directory.

* **WordPress Admin User:** See `WP_ADMIN_USER`
* **WordPress Password:** See `WP_ADMIN_PASSWORD`
* **Database User:** See `MYSQL_USER`

## 5. Status Check
To verify if the website is running correctly, type:
```bash
docker ps
