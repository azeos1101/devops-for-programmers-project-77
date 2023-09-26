inventory_path := ./inventory/webservers.yml
vault_decrypt := --vault-password-file ../password_file
vault_file := vault.yml


# Ansible
# Local tools
install_deps:
	ansible-galaxy install -r requirements.yml

ansible_init: install_deps

inventory_list:
	ansible-inventory -i $(inventory_path) $(vault_decrypt) --list

ping:
	ansible all -i $(inventory_path) $(vault_decrypt) -m ping

# Vault
vault_decrypt:
	ansible-vault decrypt $(vault_decrypt) $(vault_file)

vault_encrypt:
	ansible-vault encrypt $(vault_decrypt) $(vault_file)

vault_secrets:
	ansible-vault view $(vault_decrypt) $(vault_file)

# Playbooks
install_packages:
	ansible-playbook playbook.yml -i $(inventory_path) $(vault_decrypt) -t setup

deploy:
	ansible-playbook playbook.yml -i $(inventory_path) $(vault_decrypt) -t deploy

datadog:
	ansible-playbook playbook.yml -i $(inventory_path) $(vault_decrypt) -t datadog

ansible_play:
	ansible-playbook playbook.yml -i $(inventory_path) $(vault_decrypt)

ansible_run: ping ansible_init ansible_play
