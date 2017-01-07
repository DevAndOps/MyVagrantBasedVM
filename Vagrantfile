# -*- mode: ruby -*-
# vi: set ft=ruby :

if (ENV['VAULT_DATA_FOLDER'].nil?) 
 raise("VAULT_DATA_FOLDER is missing")
end

if (ENV['VAULT_KEY'].nil?) 
 raise("VAULT_KEY is missing")
end

if (ENV['VAULT_TOKEN'].nil?) 
 raise("VAULT_TOKEN is missing")
end

if (ENV['SSH_FOLDER'].nil?) 
 raise("SSH_FOLDER is missing")
end

if (ENV['GIT_EMAIL'].nil?) 
 raise("GIT_EMAIL is missing")
end

if (ENV['GIT_USERNAME'].nil?) 
 raise("GIT_USERNAME is missing")
end

if (ENV['SSH_PRIVATEKEY'].nil?) 
 raise("SSH_PRIVATEKEY is missing")
end

$vault_data = ENV['VAULT_DATA_FOLDER']
$vault_key = ENV['VAULT_KEY']
$vault_token = ENV['VAULT_TOKEN']
$ssh_location = ENV['SSH_FOLDER']
$git_email = ENV['GIT_EMAIL']
$git_username = ENV['GIT_USERNAME']
$ssh_privatekey = ENV['SSH_PRIVATEKEY']

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64Updated"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
   config.vm.synced_folder $vault_data, "/home/vagrant/docker/vault/vault_data"
   config.vm.synced_folder $ssh_location, "/home/vagrant/.ssh",
       mount_options: ["dmode=700,fmode=700"]


  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use. 
  config.vm.provision "fix-no-tty", type: "shell" do |s|
    s.privileged = false
    s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
  end
  config.vm.provision "EnvVaribles", type: "file" do |f|
    f.source = "./EnvVaribles.txt"
    f.destination = "~/EnvVaribles.txt"
  end
  config.vm.provision "PrepareMyAppEnvironment", type: "shell" do |s|
    # adding bash complition for docker-compose
    s.inline = "curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose"
    s.inline = "chown -R vagrant:vagrant /home/vagrant/docker"
  end
  config.vm.provision "DockerComposer", type: "file" do |f|
    f.source = "./docker-compose.yml"
    f.destination = "/home/vagrant/docker/docker-compose.yml"
  end
  config.vm.provision "VaultConfiguration", type: "file" do |f|
    f.source = "./VaultConfiguration"
    f.destination = "/home/vagrant/docker/vault/configuration"
  end
  config.vm.provision "AddedProfile", type: "file" do |f|
    f.source = "./additionalProfileContent.txt"
    f.destination = "/home/vagrant/additionalProfileContent.txt"
  end
  config.vm.provision "shell" do |s|
    s.path = "PrepareMyApp.sh"
    s.privileged = false
    s.env = { "GitEmail" => $git_email,
              "GitUsername" => $git_username,
              "ssh_privatekey" => $ssh_privatekey
    }
  end
  config.vm.provision "shell" do |s|
    s.path = "script.sh"
    s.env = { "Username" => "vagrant",
              "Vault_Key" => $vault_key,
              "Vault_token" => $vault_token
    }
  end
end
