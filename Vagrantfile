# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/arch"
  config.vm.network "forwarded_port", guest: 18112, host: 18112, host_ip: "127.0.0.1"
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
  config.vm.provision "shell", path: "bootstrap/start-qbittorrent.sh"
end
