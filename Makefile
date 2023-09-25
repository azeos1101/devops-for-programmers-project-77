terraform_path := -chdir=./terraform
ansible_path := ./ansible
inventory_path := $(ansible_path)/webservers.yml
playbook_path := $(ansible_path)/playbook.yml
vault_decrypt := --vault-password-file password_file
vault_file := vault.yml

# Terraform
terra_encrypt:
	ansible-vault encrypt $(vault_decrypt) ./terraform/vars.auto.tfvars

terra_decrypt:
	ansible-vault decrypt $(vault_decrypt) ./terraform/vars.auto.tfvars

terra_plan: terra_decrypt
	terraform $(terraform_path) plan
	$(MAKE) terra_encrypt

terra_run: terra_decrypt
	terraform $(terraform_path) init
	terraform $(terraform_path) apply -auto-approve
	terraform $(terraform_path) output -raw webservers_yml > ./ansible/webservers.yml
	terraform $(terraform_path) output -raw db_yml > ./ansible/group_vars/webservers/db.yml
	ansible-vault encrypt --vault-password-file password_file ./ansible/group_vars/webservers/db.yml
	$(MAKE) terra_encrypt

# Ansible
# Local tools
install_deps:
	ansible-galaxy install -r $(ansible_path)/requirements.yml

init: install_deps

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
	ansible-playbook $(playbook_path) -i $(inventory_path) $(vault_decrypt) -t setup

deploy:
	ansible-playbook $(playbook_path) -i $(inventory_path) $(vault_decrypt) -t deploy

datadog:
	ansible-playbook $(playbook_path) -i $(inventory_path) $(vault_decrypt) -t datadog

play:
	ansible-playbook $(playbook_path) -i $(inventory_path) $(vault_decrypt)
