# Developer Documentation - Inception

This document describes how to set up, build, and manage the Inception project.

## Prerequisites

### Required Software

| Software | Version | Installation |
|----------|---------|--------------|
| Docker Engine | 20.10+ | [Install Docker](https://docs.docker.com/engine/install/) |
| Docker Compose | v2+ | Included with Docker Desktop |
| Make | Any | `apt install make` |
| Git | Any | `apt install git` |

### Virtual Machine Setup

1. Install Debian 11 (Bullseye) or Ubuntu 22.04
2. Install Docker:
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

3. Configure domain:
```bash
echo "127.0.0.1 fhauba.42.fr" | sudo tee -a /etc/hosts
```

## Project Structure

```
inception/
├── Makefile                 # Build automation
├── secrets/                 # Docker secrets (gitignored)
│   ├── credentials.txt      # WP admin/user credentials
│   ├── db_password.txt      # Database password
│   └── db_root_password.txt # Database root password
├── srcs/
│   ├── .env                 # Environment variables
│   ├── docker-compose.yml   # Service definitions
│   └── requirements/
│       ├── nginx/
│       │   ├── Dockerfile
│       │   ├── conf/nginx.conf
│       │   └── tools/
│       ├── wordpress/
│       │   ├── Dockerfile
│       │   ├── conf/www.conf
│       │   └── tools/setup-wordpress.sh
│       └── mariadb/
│           ├── Dockerfile
│           ├── conf/50-server.cnf
│           └── tools/init-db.sh
├── README.md
├── USER_DOC.md
└── DEV_DOC.md
```

## Configuration Files

### Environment Variables (srcs/.env)

```bash
DOMAIN_NAME=fhauba.42.fr    # Your domain
MYSQL_DATABASE=wordpress     # Database name
MYSQL_USER=wpuser           # Database user
MYSQL_HOST=mariadb          # Database host (service name)
WP_TITLE=Inception          # WordPress site title
WP_URL=https://fhauba.42.fr # WordPress URL
DATA_PATH=/home/fhauba/data # Host data directory
```

### Secrets Setup

Create the following files in `secrets/`:

**credentials.txt**:
```
WP_ADMIN_USER=supervisor
WP_ADMIN_PASSWORD=YourSecurePassword123!
WP_ADMIN_EMAIL=admin@fhauba.42.fr
WP_USER=fhauba
WP_USER_PASSWORD=AnotherSecurePass456!
WP_USER_EMAIL=user@fhauba.42.fr
```

**db_password.txt**: Single line with database password
**db_root_password.txt**: Single line with root password

## Building the Project

### Initial Build
```bash
# Create data directories, build images, start containers
make all
```

### Build Images Only
```bash
make build
```

### Rebuild from Scratch
```bash
make re
```

## Makefile Commands

| Command | Description |
|---------|-------------|
| `make all` | Setup directories, build, and start |
| `make setup` | Create data directories |
| `make build` | Build Docker images |
| `make up` | Start containers |
| `make down` | Stop and remove containers |
| `make start` | Start stopped containers |
| `make stop` | Stop running containers |
| `make restart` | Restart all containers |
| `make logs` | Follow container logs |
| `make ps` | Show container status |
| `make clean` | Remove containers and networks |
| `make fclean` | Full cleanup (including volumes) |
| `make re` | Full rebuild |
| `make status` | Show detailed status |

## Container Management

### View Logs
```bash
# All containers
make logs

# Specific container
docker logs -f nginx
docker logs -f wordpress
docker logs -f mariadb
```

### Access Container Shell
```bash
docker exec -it nginx /bin/bash
docker exec -it wordpress /bin/bash
docker exec -it mariadb /bin/bash
```

### Inspect Container
```bash
docker inspect nginx
docker inspect wordpress
docker inspect mariadb
```

## Volume Management

### List Volumes
```bash
docker volume ls
```

### Inspect Volume
```bash
docker volume inspect srcs_wordpress_files
docker volume inspect srcs_mariadb_data
```

### Data Persistence
Data is stored on the host at:
- WordPress: `/home/fhauba/data/wordpress`
- MariaDB: `/home/fhauba/data/mariadb`

### Backup Volumes
```bash
# WordPress files
sudo tar -czvf wp-files.tar.gz /home/fhauba/data/wordpress

# Database
docker exec mariadb mysqldump -u root -p"$(cat secrets/db_root_password.txt)" wordpress > db-backup.sql
```

### Restore Database
```bash
cat db-backup.sql | docker exec -i mariadb mysql -u root -p"$(cat secrets/db_root_password.txt)" wordpress
```

## Network Management

### View Network
```bash
docker network ls
docker network inspect inception
```

### Container Connectivity
Containers communicate via service names:
- `nginx` → `wordpress:9000`
- `wordpress` → `mariadb:3306`

## Debugging

### Common Issues

**Port 443 already in use**:
```bash
sudo lsof -i :443
sudo kill <PID>
```

**Permission denied on volumes**:
```bash
sudo chown -R 1000:1000 /home/fhauba/data
```

**Database connection refused**:
```bash
# Check MariaDB is ready
docker logs mariadb
# Test connection
docker exec -it wordpress mysqladmin ping -h mariadb
```

### Rebuild Single Service
```bash
docker compose -f srcs/docker-compose.yml build nginx
docker compose -f srcs/docker-compose.yml up -d nginx
```

## Security Considerations

1. **Never commit secrets** - They're in `.gitignore`
2. **Change default passwords** before deployment
3. **TLS only** - No HTTP, only HTTPS (port 443)
4. **Isolated network** - Services communicate internally
5. **No root** - Services run as non-root users where possible

## Adding Bonus Services

Create new service in `srcs/requirements/bonus/`:
```
bonus/
└── redis/
    ├── Dockerfile
    ├── conf/
    └── tools/
```

Add to `docker-compose.yml`:
```yaml
redis:
  build: ./requirements/bonus/redis
  container_name: redis
  restart: unless-stopped
  networks:
    - inception
```
