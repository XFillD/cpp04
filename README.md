*This project has been created as part of the 42 curriculum by fhauba.*

# Inception

## Description
Inception is a System Administration project that involves setting up a small infrastructure using **Docker Compose**. The goal is to build a web server stack from scratch using containers, understanding the specific rules of microservices, data persistence, and networking.

The infrastructure consists of three separate services:
* **NGINX:** The secure entry point (HTTPS/TLS) for the website.
* **WordPress + PHP-FPM:** The dynamic content processor (backend).
* **MariaDB:** The database storage.

Each service runs in its own dedicated container, isolated from the others, communicating only through a private Docker network.

## Instructions
1.  **Clone the repository:**
2.  **Setup Environment:**
    Ensure a `.env` file is present in `srcs/` containing the required database credentials.
3.  **Launch:**
    Use the Makefile to build and start the infrastructure.
    ```bash
    make
    ```
4.  **Access:**
    Open `https://fhauba.42.fr` in your browser.

## Project Description & Architecture Choices

### Virtual Machines vs Docker
* **Virtual Machines (VMs):** Emulate an entire physical computer, including the hardware and a full Operating System (OS). They are heavy, slow to boot, and use a lot of RAM.
* **Docker (Containers):** Virtualizes only the OS level. Containers share the Host's kernel but have their own isolated user space. They are extremely lightweight, start instantly, and are more efficient than VMs for running specific applications.

### Secrets vs Environment Variables
* **Environment Variables:** Stored in `.env` files and passed to the container at runtime. They are easy to use but can be insecure if the file is committed to Git or if someone runs `docker inspect`.
* **Secrets:** A more secure way to manage sensitive data (passwords, keys). In Docker Swarm, secrets are encrypted during transit and at rest. For this project, we used **Environment Variables** (as per the subject's strict requirement for a `.env` file), but we ensured the file is not publicly tracked.

### Docker Network vs Host Network
* **Host Network:** The container shares the exact same IP and port space as the host machine. This offers no isolation; if two containers want port 80, they conflict.
* **Docker Network (Bridge):** Creates a private internal network. Containers get their own internal IP addresses and can talk to each other using their service names (DNS resolution). This is more secure because we can hide the Database from the outside world and only expose NGINX.

### Docker Volumes vs Bind Mounts
* **Bind Mounts:** Directly link a folder on your Host (e.g., `/home/user/desktop`) to a folder in the container. They depend on the specific file structure of the host machine.
* **Docker Volumes:** Managed entirely by Docker. They are stored in a specific part of the host filesystem (usually `/var/lib/docker/volumes/`). They are safer, easier to back up, and work the same on any OS. In this project, we used **Named Volumes** with a custom driver device option to store data in `/home/fhauba/data` as required.

## Resources
* [Docker Documentation](https://docs.docker.com/)
* [NGINX Documentation](https://nginx.org/en/docs/)
* [WordPress CLI Commands](https://developer.wordpress.org/cli/commands/)
* **AI Usage:** Generative AI (Google Gemini) was used during this project to:
    * Debug configuration errors (specifically MySQL connection loops and NGINX routing).
    * Draft the initial structure of this documentation.
