#!/bin/sh
pacman -Sy
pacman -S openvpn qbittorrent-nox networkmanager networkmanager-openvpn \
  --noconfirm
systemctl enable NetworkManager --now
echo "bootstrap-0 is done"