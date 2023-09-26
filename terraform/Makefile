db_config_path := ../ansible/group_vars/webservers/db.yml

# Terraform
terra_format:
	terraform fmt -write

terra_plan:
	terraform plan

terra_run:
	terraform init
	terraform apply
	terraform output -raw webservers_yml > ../ansible/inventory/webservers.yml
	terraform output -raw db_yml > $(db_config_path)
	ansible-vault encrypt --vault-password-file ../password_file $(db_config_path)
