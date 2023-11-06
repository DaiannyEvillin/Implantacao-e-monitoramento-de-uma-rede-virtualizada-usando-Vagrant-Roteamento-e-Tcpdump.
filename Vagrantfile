# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  # Configuração padrão para todas as VMs
  config.vm.box = "ubuntu/focal64" # Ubuntu 20.04
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
  end

  # vm1 - Roteador
  config.vm.define "vm1" do |vm1|
    vm1.vm.hostname = "vm1-router"
    vm1.vm.network "private_network", ip: "192.168.50.1"
    vm1.vm.network "private_network", ip: "192.168.60.1"
    vm1.vm.provision "shell", path: "provisions/provision_vm1.sh"
  end

  # vm2 - Host 1
  config.vm.define "vm2" do |vm2|
    vm2.vm.hostname = "vm2-host1"
    vm2.vm.network "private_network", ip: "192.168.50.10"
    vm2.vm.provision "shell", path: "provisions/provision_vm2.sh"
  end

  # vm3 - Host 2
  config.vm.define "vm3" do |vm3|
    vm3.vm.hostname = "vm3-host2"
    vm3.vm.network "private_network", ip: "192.168.60.10"
    vm3.vm.provision "shell", path: "provisions/provision_vm3.sh"
  end

end
