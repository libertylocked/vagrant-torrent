#!/bin/sh
echo "Starting qBittorrent service"
systemctl enable qbittorrent-nox@vagrant.service --now
