vagrant-torrent
---
An Arch Linux VM for torrenting with qBittorrent.

# Features
- WebUI to manage torrents
- qBittorrent binds on OpenVPN interface tun0
  - In case VPN disconnects, torrents will stop too
- `btw i use arch`

# Operations Manual

## Requirements
- Vagrant
- VirtualBox
  - HyperV is not supported yet, but maybe in the future?

## Setup
- Put OpenVPN config in `config/vpn-conf.ovpn`
  - Please note that only TUN interface is supported at this moment (it should be `dev tun` in the file)
- Put OpenVPN password in `config/vpn-creds.txt`
  - Put username on first line, password on second line
  - The credentials file can be deleted once the VM is provisioned

## Usage
- Run `vagrant up`
- Visit `http://localhost:18112` with default qBittorrent username and password
  - At the time of writing, it should be `admin:adminadmin`
- Please change the default password in qBittorrent
- Start adding torrents. The files should show up in `downloads` folder
- Use `vagrant halt` to shutdown the VM

## Cleanup
- Run `vagrant destroy` to destroy the VM instance
- If you want to delete the Arch Linux box, run `vagrant box remove generic/arch --all`
