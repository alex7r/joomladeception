Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/xenial64"
    # config.vm.network "public_network"
    # config.vm.network "private_network", ip: "192.168.33.222"
    config.vm.provision :shell, path: "attach/setup_host.sh"
    config.vm.provision :shell do |j|
        j.path = "attach/setup_joomla.sh"
        j.args = ['3.7.2','prfx_','qweasd','admin','joomla_db','jdbuser','dbupass']
    end
    config.vm.provision :shell, path: "attach/fix_htaccess.sh"
    config.vm.provision :shell, path: "attach/setup_devtools.sh"
    # config.vm.provision :shell, path: "attach/setup_codeception.sh"
    # config.vm.provision :shell, path: "attach/setup_phantomjs.sh"
    # config.vm.provision :shell, path: "attach/prepare_codeception.sh"
    config.vm.provision "shell", inline: "ifconfig | grep 'inet addr'"
    # config.vm.provision "shell", inline: "chown -R ubuntu:www-data /var/www/html/"
    config.vm.provision :shell, path: "attach/cleanup.sh"
    # config.vm.synced_folder ".", "/vagrant", disabled: true
    config.vm.synced_folder "./attach", "/docker-attach"
    # config.ssh.insert_key = true
    config.vm.provider "virtualbox" do |vb|
        vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    end
end