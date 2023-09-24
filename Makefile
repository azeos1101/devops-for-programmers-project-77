vault_decrypt := --vault-password-file password_file
vault_file := vault.yml
terraform_path := -chdir=./terraform

# Terraform
terra_init:
	terraform $(terraform_path) init

terra_apply:
	terraform $(terraform_path) apply

terra_plan:
	terraform $(terraform_path) plan

# 	echo 1

# # ansible
# install_deps:
# 	ansible-galaxy install -r requirements.yml

# init: install_deps

# inventory_list:
# 	ansible-inventory -i inventory.yml $(vault_decrypt) --list

# ping:
# 	ansible all -i inventory.yml $(vault_decrypt) -m ping

# # Vault
# vault_decrypt:
# 	ansible-vault decrypt $(vault_decrypt) $(vault_file)

# vault_encrypt:
# 	ansible-vault encrypt $(vault_decrypt) $(vault_file)

# vault_secrets:
# 	ansible-vault view $(vault_decrypt) $(vault_file)


# # Playbooks
# install_packages:
# 	ansible-playbook -v playbook.yml -i inventory.yml $(vault_decrypt) -t setup

# deploy:
# 	ansible-playbook -v playbook.yml -i inventory.yml $(vault_decrypt) -t deploy

# datadog:
# 	ansible-playbook -v playbook.yml -i inventory.yml $(vault_decrypt) -t datadog

# play:
# 	ansible-playbook -v playbook.yml -i inventory.yml $(vault_decrypt)
