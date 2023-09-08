# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  # Forward port 8080 for access to the VSCode container
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"

  config.vm.synced_folder "./vagrant_data", "/media/vagrant"

  config.vm.provider "parallels" do |prl|
    prl.name = "norm_robotics_dev"
    prl.update_guest_tools = true
  end

  config.vm.provision "shell", path: "./provisioner.sh", privileged: false
end
