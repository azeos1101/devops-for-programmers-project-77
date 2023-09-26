terraform_path := ./terraform
ansible_path := ./ansible

terra_plan:
	$(MAKE) -C $(terraform_path) terra_plan

terra_format:
	$(MAKE) -C $(terraform_path) terra_format

terra_run:
	$(MAKE) -C $(terraform_path) terra_run

ansible_run:
	$(MAKE) -C $(ansible_path) ansible_run
