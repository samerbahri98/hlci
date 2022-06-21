require 'yaml'

current_dir = File.dirname((File.expand_path(__FILE__)))
rcfile = YAML.load_file("#{current_dir}/vagrantrc.yml")

rcfile["vms"].each do |vm_rc|
    Vagrant.configure("2") do |config|
        config.ssh.private_key_path = "hlci_ansible"
        config.vm.define vm_rc["name"] do |machine|
            machine.vm.provider "docker" do |d|
                d.build_dir =  "."
                d.has_ssh = true
                d.remains_running = false
                d.ports = ["4440:4440"]
            end
            machine.ssh.forward_agent = true
            machine.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=775,fmode=664"]
            machine.vm.provision "shell", path: vm_rc["bootstrap"]
            machine.vm.provision "ansible_local" do |ansible|
                ansible.verbose = "vvv"
                ansible.install = false
                ansible.playbook = "ansible/playbooks/ac.yml"
                ansible.inventory_path = "ansible"
                ansible.config_file = "ansible.cfg"
                ansible.vault_password_file = "hlci_ansible_vault"
                ansible.galaxy_role_file = "ansible/galaxy/requirements.yml"
            end
            machine.vm.provision "shell", path: vm_rc["cleanup"]
        end
    end
end