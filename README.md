vagrant-torrent
---
An Arch Linux VM for torrenting with qBittorrent, on OpenVPN or WireGuard

# Features
- qBittorrent binds on VPN interface only
  - In case VPN disconnects, torrents will stop too
- WireGuard support
- WebUI port forwarded to host, to manage torrents in browser
- Portable qBittorrent config and data
  - Saved in `downloads/.qbit`
  - Never lose in-progress torrents when VM instance is destroyed
- `btw i use arch`

# Instructions

## Requirements
- Vagrant
- VirtualBox
  - Or Hyper-V, but it is not tested

## Setup
- If using OpenVPN:
  - Put OpenVPN config in `config/ovpn0.ovpn`
    - Please note that only TUN interface is supported at this moment (it should be `dev tun` in the file)
    - If your VPN config comes with a crt file, you must embed it in the .ovpn file. Do a Google search on how to *embed certificate in ovpn file*. 
  - Put OpenVPN password in `config/ovpn0-creds.txt`
    - Put username on first line, password on second line
    - The credentials file can be deleted once the VM is provisioned
- If using WireGuard:
  - Put WireGuard config file in `config/wg0.conf`
- *Optional*: If you wish to change the port of the forwarded WebUI, create a `settings.json` in config
  - You can try `cp ./config/settings.json.default ./config/settings.json` then edit the port

Any changes to the config folder need a reprovision to take effect.

## Usage
- Run `vagrant up`
- Visit `http://localhost:8080` (or the custom port you set) with default qBittorrent username and password
  - At the time of writing, it should be `admin:adminadmin`
- Please change the default password in qBittorrent
- Start adding torrents. The files should show up in `downloads` folder
- Use `vagrant halt` to shutdown the VM

## Cleanup
- Run `vagrant destroy` to destroy the VM instance
- If you want to delete the Arch Linux box, run `vagrant box remove generic/arch --all`

# FAQ
### Help I messed up my qBittorrent config
To revert to default qBittorrent configs, follow these steps:

- Shutdown VM with `vagrant halt`
- Delete `downloads/.qbit` when the VM is powered off
- Run `vagrant reload --provision`

Note that you will lose all the torrents in the transfer list (but you won't lose the downloaded files).

### I need to change my VPN config and/or my VPN credentials
Just drop the new files into `config` folder and run `vagrant reload --provision`.

### Torrents aren't downloading. Is my VPN working?
- On host, run `vagrant ssh` to SSH into the VM
- Run `ip addr` and see if there exists `tun0` or `wg0` interface
  - If not, the VPN isn't working
  - OpenVPN: Pull up logs with `sudo journalctl -u openvpn-client@ovpn0.service` for further diagnosis
  - WireGuard: `sudo journalctl -u wg-quick@wg0.service`

### What is my external IP shown to peers?
Check `downloads/.qbit/.local/share/data/qBittorrent/logs/qbittorrent.log` and look for the line "Detected external IP: xxx.xxx.xxx.xxx".