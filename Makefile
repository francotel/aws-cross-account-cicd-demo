SHELL := /usr/bin/env bash
.EXPORT_ALL_VARIABLES:

devops:
	$(eval AWS_PROFILE   = $(shell echo "orion-aws"))

dev:
	$(eval AWS_PROFILE   = $(shell echo "scc-aws"))

qa:
	$(eval AWS_PROFILE   = $(shell echo "orion-aws"))

prod:
	$(eval AWS_PROFILE   = $(shell echo "orion-aws"))

# HOW TO EXECUTE

# Executing Terraform PLAN
#	$ make tf-plan env=<env>
#       make tf-plan env=dev

# Executing Terraform APPLY
#   $ make tf-apply env=<env>

# Executing Terraform DESTROY
#	$ make tf-destroy env=<env>
	
#####  TERRAFORM  #####
all-test: clean tf-plan

.PHONY: clean tf-output tf-init tf-plan tf-apply tf-destroy
	rm -rf .terraform

tf-setup-backend: $(env)
	cd 01-setup-backend-tf && terraform init -reconfigure -upgrade && terraform validate && terraform fmt && terraform plan && terraform apply

tf-cross-role: $(env)
	cd 02-cross-account-setup && \
	terraform init -reconfigure -upgrade && \
	terraform validate && terraform fmt && terraform plan -var env=$(env) && \
	terraform apply -auto-approve -var env=$(env)

tf-github-oidc: $(env)
	cd 03-devops-account && \
	terraform init -reconfigure -upgrade && \
	terraform validate && terraform fmt && terraform plan -var env=$(env) && \
	terraform apply -var env=$(env)

tf-init: $(env)
	terraform init -reconfigure -upgrade && terraform validate 

tf-plan: $(env)
	terraform fmt --recursive && terraform validate && terraform plan -var-file *.tfvars -out=tfplan

tf-apply: $(env)
	terraform fmt --recursive && terraform validate && terraform apply -auto-approve --input=false tfplan

tf-destroy: $(env)
	terraform destroy -var-file *.tfvars

tf-output: $(env)
	AWS_PROFILE=${AWS_PROFILE} terraform output