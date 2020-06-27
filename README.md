vagrant-torrent
---
An Arch Linux VM for torrenting with qBittorrent.

# Requirements
- Vagrant
- VirtualBox
  - HyperV is not supported yet, but maybe in the future?

# Operations Manual

## Setup
- Put OpenVPN config in `config/vpn-conf.ovpn`
- Put OpenVPN password in `config/vpn-creds.txt`
  - The credentials file can be deleted after the VM is provisioned

## Usage
- Run `vagrant up`
- Visit `http://localhost:18112` with default qBittorrent username and password
  - At the time of writing, it should be `admin:adminadmin`
- Please change the default password in qBittorrent
- Start adding torrents. The files should show up in `downloads` folder
- Use `vagrant halt` to suspend the VM

## Cleanup
- Run `vagrant destroy` to destroy the VM instance
- If you want to delete the Arch Linux box, run `vagrant box remove generic/arch --all`
