terraform_path := ./terraform
ansible_path := ./ansible

# Terrraform
terra_plan:
	$(MAKE) -C $(terraform_path) terra_plan

terra_format:
	$(MAKE) -C $(terraform_path) terra_format

terra_run:
	$(MAKE) -C $(terraform_path) terra_run

# Ansible

ansible_run:
	$(MAKE) -C $(ansible_path) ansible_run

deploy:
	$(MAKE) -C $(ansible_path) ansible_deploy

# Secrets
vault_decrypt:
	$(MAKE) -C $(ansible_path) vault_decrypt

vault_encrypt:
	$(MAKE) -C $(ansible_path) vault_encrypt

vault_secrets:
	$(MAKE) -C $(ansible_path) vault_secrets

# Tools
ping:
	$(MAKE) -C $(ansible_path) ping

inventory_list:
	$(MAKE) -C $(ansible_path) inventory_list
