# User Documentation - Inception

This document explains how to use and manage the Inception infrastructure.

## Overview

Inception provides a complete WordPress website running on:
- **NGINX** - Secure web server (HTTPS only)
- **WordPress** - Content Management System
- **MariaDB** - Database

## Services Provided

| Service | Description | Access |
|---------|-------------|--------|
| WordPress Website | Main website | https://fhauba.42.fr |
| WordPress Admin | Administration panel | https://fhauba.42.fr/wp-admin |
| Database | MariaDB (internal only) | Not directly accessible |

## Starting the Project

```bash
# Start all services
make up

# Or build and start
make all
```

## Stopping the Project

```bash
# Stop containers (preserves data)
make down

# Stop without removing containers
make stop

# Restart all services
make restart
```

## Accessing the Website

1. **Main Website**: Open https://fhauba.42.fr in your browser
2. **Admin Panel**: Open https://fhauba.42.fr/wp-admin

### SSL Certificate Warning
The project uses a self-signed certificate. Your browser will show a security warning - this is normal. Click "Advanced" and proceed to the website.

## Credentials

### Location
Credentials are stored in the `secrets/` directory:

| File | Contents |
|------|----------|
| `secrets/credentials.txt` | WordPress admin and user credentials |
| `secrets/db_password.txt` | Database user password |
| `secrets/db_root_password.txt` | Database root password |

### Default WordPress Users

| User | Role | Purpose |
|------|------|---------|
| supervisor | Administrator | Full site management |
| fhauba | Author | Content creation |

**Important**: Change these passwords before deploying to production!

## Managing Credentials

### Changing WordPress Password
1. Login to https://fhauba.42.fr/wp-admin
2. Go to Users → Your Profile
3. Scroll to "Account Management"
4. Click "Set New Password"

### Changing Database Password
1. Update `secrets/db_password.txt`
2. Update `secrets/credentials.txt` if needed
3. Rebuild containers: `make re`

## Health Checks

### Check All Services
```bash
make status
```

### Check Individual Services
```bash
# View running containers
docker ps

# Check NGINX
docker logs nginx

# Check WordPress
docker logs wordpress

# Check MariaDB
docker logs mariadb
```

### Verify HTTPS
```bash
curl -k https://fhauba.42.fr
```

### Test Database Connection
```bash
docker exec -it mariadb mysql -u wpuser -p wordpress
```

## Troubleshooting

### Website Not Loading
1. Check if containers are running: `make status`
2. Check NGINX logs: `docker logs nginx`
3. Verify domain resolution: `ping fhauba.42.fr`

### Database Connection Failed
1. Check MariaDB is running: `docker logs mariadb`
2. Verify credentials match in `.env` and secrets
3. Restart services: `make restart`

### Permission Issues
```bash
# Fix volume permissions
sudo chown -R 1000:1000 /home/fhauba/data
```

## Data Locations

| Data | Host Path | Container Path |
|------|-----------|----------------|
| WordPress files | `/home/fhauba/data/wordpress` | `/var/www/html` |
| Database | `/home/fhauba/data/mariadb` | `/var/lib/mysql` |

## Backup

### Backup WordPress Files
```bash
sudo tar -czvf wordpress-backup.tar.gz /home/fhauba/data/wordpress
```

### Backup Database
```bash
docker exec mariadb mysqldump -u root -p wordpress > backup.sql
```
