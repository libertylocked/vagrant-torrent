#!/bin/sh
echo "Starting qBittorrent"
systemctl enable qbittorrent-nox@vagrant.service
systemctl restart qbittorrent-nox@vagrant.service