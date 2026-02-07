*This project has been created as part of the 42 curriculum by fhauba.*

# Inception

A Docker-based infrastructure project implementing a complete LEMP stack (Linux, NGINX, MariaDB, PHP) with WordPress.

## Description

This project sets up a small infrastructure composed of different services running in Docker containers:

- **NGINX** - TLS-enabled reverse proxy (TLSv1.2/TLSv1.3 only)
- **WordPress** - CMS with PHP-FPM
- **MariaDB** - Database server

All services are containerized, follow security best practices, and communicate through a Docker network.

### Design Choices

#### Virtual Machines vs Docker

| Aspect | Virtual Machines | Docker Containers |
|--------|-----------------|-------------------|
| Resource Usage | Heavy (full OS) | Lightweight (shared kernel) |
| Startup Time | Minutes | Seconds |
| Isolation | Complete hardware virtualization | Process-level isolation |
| Portability | Limited (large images) | High (small images) |
| Use Case | Full OS isolation, legacy apps | Microservices, rapid deployment |

**This project uses Docker** for its lightweight nature, fast deployment, and microservices architecture.

#### Secrets vs Environment Variables

| Aspect | Docker Secrets | Environment Variables |
|--------|---------------|----------------------|
| Security | Encrypted, stored in memory | Visible in process list |
| Access | Only available to authorized services | Available to all processes |
| Storage | Managed by Docker Swarm/Compose | In .env files or shell |
| Best For | Passwords, API keys, certificates | Configuration, paths, names |

**This project uses both**: Secrets for passwords, environment variables for configuration.

#### Docker Network vs Host Network

| Aspect | Docker Network (Bridge) | Host Network |
|--------|------------------------|--------------|
| Isolation | Containers isolated | No isolation |
| Security | Better (controlled access) | Weaker (all ports exposed) |
| Port Mapping | Explicit (443:443) | Not needed |
| Container Communication | Via service names | Via localhost |

**This project uses Bridge Network** for security and proper isolation between services.

#### Docker Volumes vs Bind Mounts

| Aspect | Named Volumes | Bind Mounts |
|--------|--------------|-------------|
| Management | Managed by Docker | Manual |
| Portability | Better (Docker handles) | Host-dependent |
| Backup | Easier with Docker commands | Manual file operations |
| Use Case | Databases, persistent data | Development, config files |

**This project uses Named Volumes** as required, storing data in `/home/fhauba/data/`.

## Instructions

### Prerequisites

- Virtual Machine with Debian/Ubuntu
- Docker Engine 20.10+
- Docker Compose v2+
- Make

### Installation

1. Clone the repository:
```bash
git clone <repository> inception
cd inception
```

2. Configure your domain in `/etc/hosts`:
```bash
echo "127.0.0.1 fhauba.42.fr" | sudo tee -a /etc/hosts
```

3. Update secrets in `secrets/` directory with your own passwords.

4. Build and start:
```bash
make all
```

### Usage

```bash
make up       # Start all containers
make down     # Stop all containers
make logs     # View container logs
make status   # Check container status
make clean    # Remove containers and networks
make fclean   # Full cleanup including volumes
make re       # Rebuild everything
```

## Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Codex](https://codex.wordpress.org/)
- [MariaDB Documentation](https://mariadb.com/kb/en/)

### Tutorials
- [Docker Best Practices](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [PID 1 in Containers](https://blog.phusion.nl/2015/01/20/docker-and-the-pid-1-zombie-reaping-problem/)

### AI Usage
AI tools were used for:
- Generating boilerplate Dockerfile configurations
- Troubleshooting Docker networking issues
- Optimizing shell scripts for container entrypoints

All AI-generated content was reviewed, understood, and modified to meet project requirements.

## Author

- **fhauba** - 42 Prague
