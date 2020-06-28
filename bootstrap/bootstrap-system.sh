#!/bin/sh
# install packages
pacman -Sy
pacman -S openvpn qbittorrent-nox jq --noconfirm

# setup vpn
mv /home/vagrant/.provision_config/vpn-conf.ovpn /etc/openvpn/client/vpn-conf.conf
mv /home/vagrant/.provision_config/vpn-creds.txt /etc/openvpn/vpn-creds.txt
chmod 400 /etc/openvpn/vpn-creds.txt
sed -i '/^auth-user-pass/d' /etc/openvpn/client/vpn-conf.conf
echo "" >> /etc/openvpn/client/vpn-conf.conf
echo "auth-user-pass /etc/openvpn/vpn-creds.txt" >> /etc/openvpn/client/vpn-conf.conf
systemctl enable openvpn-client@vpn-conf.service
systemctl restart openvpn-client@vpn-conf.service