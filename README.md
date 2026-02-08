*42 school project by fhauba — system administration with Docker.*

# Inception

## Overview
Inception is a hands-on infrastructure project where a complete web-hosting stack is assembled from individual Docker containers. It covers container orchestration, network isolation, persistent storage, and secure communication.

Three independent services make up the stack:
* **NGINX** — reverse proxy that terminates TLS and serves as the single public-facing endpoint.
* **WordPress + PHP-FPM** — application layer responsible for rendering dynamic pages.
* **MariaDB** — relational database that holds all site content.

Every service lives in its own container; inter-service traffic flows exclusively over an internal Docker bridge network.

## Quick Start
1.  **Clone the repo.**
2.  **Prepare the environment:**
    Make sure `srcs/.env` exists and contains valid database and WordPress credentials.
3.  **Build & run:**
    ```bash
    make
    ```
4.  **Open the site:**
    Visit `https://fhauba.42.fr` in a browser.

## Architecture & Design Decisions

### Containers over Virtual Machines
* **VMs** spin up an entire operating system with its own kernel, which makes them resource-heavy and slow to start.
* **Containers** share the host kernel while keeping user-space isolated. They boot in milliseconds, consume far less memory, and are ideal for packaging single-purpose services like a web server or a database.

### Environment Variables for Configuration
* **Env vars** (loaded from a `.env` file at runtime) are the simplest way to inject credentials into containers. The trade-off is that they are visible via `docker inspect`.
* **Docker Secrets** offer encrypted storage but require Swarm mode. Because the project subject mandates a `.env` file, we stick with env vars while keeping the file out of version control.

### Bridge Network for Isolation
* **Host networking** shares the machine's IP stack with every container — no isolation, easy port conflicts.
* A **bridge network** gives each container its own internal address and enables DNS-based service discovery (e.g., `wordpress` can reach `mariadb` by name). Only NGINX exposes port 443 to the outside; the database stays hidden.

### Named Volumes for Persistent Storage
* **Bind mounts** tie a container to a specific host path, making it less portable.
* **Docker volumes** are managed by the engine, simple to back up, and OS-agnostic. We use named volumes with a custom `device` option so data lands in `/home/fhauba/data` as the subject requires.

## References
* [Docker Docs](https://docs.docker.com/)
* [NGINX Docs](https://nginx.org/en/docs/)
* [WP-CLI Handbook](https://developer.wordpress.org/cli/commands/)
* **AI disclosure:** Google Gemini was consulted during development to help troubleshoot database connectivity issues and to outline the initial version of this documentation.
