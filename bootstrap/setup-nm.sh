#!/bin/sh
nmcli c mod "Wired connection 1" ipv6.method disabled

# import vpn
nmcli c import type openvpn file $HOME/.provision_config/vpn.ovpn
VPN_USERNAME=$(cat $HOME/.provision_config/vpn-creds.txt | head -1)
VPN_PASSWORD=$(cat $HOME/.provision_config/vpn-creds.txt | head -2 | tail -1)
nmcli c mod vpn +vpn.data username=$VPN_USERNAME
nmcli c mod vpn +vpn.data password-flags=0
nmcli c mod vpn vpn.secrets "password=$VPN_PASSWORD"
nmcli c mod vpn connection.autoconnect yes
nmcli c mod vpn vpn.persistent yes
nmcli c mod vpn ipv6.method disabled

# set up autoconnect
VPN_UUID=$(nmcli -t -f connection.uuid c show vpn | cut -d ":" -f2)
nmcli c mod "Wired connection 1" connection.secondaries $VPN_UUID

nmcli c up vpn
