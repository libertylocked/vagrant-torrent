#!/bin/sh
# install packages
pacman -Sy
pacman -S openvpn wireguard-tools systemd-resolvconf qbittorrent-nox jq \
  --noconfirm

systemctl enable systemd-resolved.service --now

# during reprovision we need to disable the vpn services so we don't run both
# wg and ovpn at the same time
if systemctl is-active wg-quick@wg0.service > /dev/null 2>&1; then
  echo "Disabling pre-existing wg service"
  systemctl disable wg-quick@wg0.service --now
fi
if systemctl is-active openvpn-client@ovpn0.service > /dev/null 2>&1; then
  echo "Disabling pre-existing ovpn service"
  systemctl disable openvpn-client@ovpn0.service --now
fi

if [ -f /home/vagrant/.provision_config/wg0.conf ]; then
  # prefer wireguard over ovpn if config exists
  echo "Setting up WireGuard"
  mv /home/vagrant/.provision_config/wg0.conf /etc/wireguard/wg0.conf
  chmod 400 /etc/wireguard/wg0.conf
  systemctl enable wg-quick@wg0.service --now
  echo "wg0" > /home/vagrant/.provision_config/iface
elif [ -f /home/vagrant/.provision_config/ovpn0.ovpn ]; then
  # setup ovpn
  echo "Setting up OpenVPN"
  mv /home/vagrant/.provision_config/ovpn0.ovpn /etc/openvpn/client/ovpn0.conf
  mv /home/vagrant/.provision_config/ovpn0-creds.txt /etc/openvpn/ovpn0-creds.txt
  chmod 400 /etc/openvpn/ovpn0-creds.txt
  sed -i '/^auth-user-pass/d' /etc/openvpn/client/ovpn0.conf
  echo "" >> /etc/openvpn/client/ovpn0.conf
  echo "auth-user-pass /etc/openvpn/ovpn0-creds.txt" >> /etc/openvpn/client/ovpn0.conf
  systemctl enable openvpn-client@ovpn0.service --now
  echo "tun0" > /home/vagrant/.provision_config/iface
else
  echo "Missing VPN config!"
  exit 1
fi
chown vagrant:vagrant /home/vagrant/.provision_config/iface