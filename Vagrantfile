require 'yaml'

current_dir = File.dirname((File.expand_path(__FILE__)))
rcfile = YAML.load_file("#{current_dir}/vagrantrc.yml")

rcfile["vms"].each do |vm_rc|
    Vagrant.configure("2") do |config|
        config.ssh.private_key_path = "hlci_ansible"
        config.vm.define vm_rc["name"] do |machine|
            machine.vm.provider "docker" do |vb|
                vb.build_dir =  "."
                vb.remains_running  = true
                vb.has_ssh = true
            end
            machine.ssh.forward_agent = true
            machine.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=775,fmode=664"]
            machine.vm.provision "shell", path: vm_rc["bootstrap"]
            machine.vm.provision "shell", path: vm_rc["cleanup"]
        end
    end
end