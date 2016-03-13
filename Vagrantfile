# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/wily64"
  config.vm.provision :shell, path: "vagrant.sh"
  config.vm.network :forwarded_port, guest: 4000, host: 4000
  config.vm.synced_folder ".", "/home/vagrant/guerilla_radio"
end
