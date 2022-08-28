# -*- mode: ruby -*-
# vi: set ft=ruby :

# Ubuntu 20.04 LTS with
Vagrant.configure("2") do |config|
  # Box
  config.vm.box = "ubuntu/focal64"
  config.vm.box_download_insecure = true

  # Provider configuration (VirtualBox)
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 2048
    vb.name = "azure-agent-podio"
  end

  # Provisioning
  config.vm.provision "shell" do |s|
    s.path = "./install-agent-software.sh"
    s.privileged = false
    s.env = {
      "VERSION" => "2.209.0",
      "URL" => "https://dev.azure.com/",
      "ORG" => ENV['AZURE_AGENT_ORG'],
      "TOKEN" => ENV['AZURE_AGENT_TOKEN'],
      "NAME" => ENV['AZURE_AGENT_NAME']
    }
  end

  # # Network
  # config.vm.network "public_network"
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # # Synced folders
  # config.vm.synced_folder "./data", "/vagrant_data"
end
