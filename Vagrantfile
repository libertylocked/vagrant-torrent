# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

cfg_filename_user = './config/settings.json'
cfg_filename_default = './config/settings.json.default'
cfg_filename = ''
if File.file?(cfg_filename_user)
  cfg_filename = cfg_filename_user
elsif File.file?(cfg_filename_default)
  cfg_filename = cfg_filename_default
else
  abort('Error: settings json file is missing.')
end
cfg = JSON.parse(File.read(cfg_filename))

qbit_port = cfg['port']

Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"
  config.vm.network "forwarded_port", guest: qbit_port, host: qbit_port, host_ip: "127.0.0.1"
  config.vm.synced_folder "./downloads", "/home/vagrant/downloads", create: true, 
    owner: "vagrant", group: "vagrant"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--vram", "8"]
  end

  config.vm.provider "hyperv" do |h|
    h.memory = "1024"
  end

  config.vm.provision "file", source: "config", destination: "$HOME/.provision_config"
  config.vm.provision "shell", path: "bootstrap/disable-ipv6.sh"
  config.vm.provision "shell", path: "bootstrap/bootstrap-system.sh"
  config.vm.provision "file", source: "bootstrap/copy_home", destination: "$HOME"
  config.vm.provision "shell", path: "bootstrap/bootstrap-user.sh", privileged: false
  config.vm.provision "shell", path: "bootstrap/start-qbittorrent.sh", run: "always"
end
