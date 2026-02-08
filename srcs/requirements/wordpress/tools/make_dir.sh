#!/bin/bash
# Ensure the host-side bind-mount directories exist before docker compose starts
if [ ! -d "/home/fhauba/data" ]; then
        mkdir -p /home/fhauba/data/mariadb
        mkdir -p /home/fhauba/data/wordpress
fi
