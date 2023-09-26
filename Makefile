terraform_path := ./terraform
ansible_path := ./ansible

# Terrraform
terra_plan:
	make -C $(terraform_path) terra_plan

terra_format:
	make -C $(terraform_path) terra_format

terra_run:
	make -C $(terraform_path) terra_run

# Ansible

ansible_run:
	make -C $(ansible_path) ansible_run

deploy:
	make -C $(ansible_path) ansible_deploy

# Secrets
vault_decrypt:
	make -C $(ansible_path) vault_decrypt

vault_encrypt:
	make -C $(ansible_path) vault_encrypt

vault_secrets:
	make -C $(ansible_path) vault_secrets

# Tools
ping:
	make -C $(ansible_path) ping

inventory_list:
	make -C $(ansible_path) inventory_list
