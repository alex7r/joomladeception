Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/trusty64"
    config.vm.provision :shell, path: "attach/setup_host.sh"
    config.vm.provision :shell, path: "attach/setup_joomla.sh"
    config.vm.provision :shell, path: "attach/fix_htaccess.sh"
    config.vm.provision :shell, path: "attach/cleanup.sh"
    config.vm.network "private_network", ip: "192.168.33.111"
end