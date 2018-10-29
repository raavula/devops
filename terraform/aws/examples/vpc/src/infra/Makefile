ACCOUNT = $(shell echo `grep "^account" terraform.tfvars | cut -d '=' -f2 | tr -d ' ' |tr -d '"'`)
STACK = $(shell echo `grep "^stack" terraform.tfvars | cut -d '=' -f2 | tr -d ' ' |tr -d '"'`)
ACCOUNT_S3_BUCKET = $(ACCOUNT)-state
TFSTATE_FILE   = infra/terraform.state


.PHONY: check-prereq setup config plan deploy

check-prereq:
	@echo "check pre-requisites ..."
	command -v terraform >/dev/null 2>&1 || { echo "terraform is not in PATH.  Aborting." >&2; exit 1; }
	command -v aws >/dev/null 2>&1 || { echo "terraform is not in PATH.  Aborting." >&2; exit 1; }

sshkeypair-setup:
	@echo "Create keypair ..."
	ssh-keygen -t rsa -f sshkey_$(STACK)
	ssh-add sshkey_$(STACK)

s3bucket-setup:
	@echo "copy key to  S3 buckets ..."
	aws s3api put-object --bucket $(ACCOUNT_S3_BUCKET) --key sshkey/

sshkey-put:
	@echo "Upload ssh key to S3 buckets ..."
	aws s3 cp sshkey_$(STACK) s3://$(ACCOUNT_S3_BUCKET)/sshkey/
	aws s3 cp sshkey_$(STACK).pub s3://$(ACCOUNT_S3_BUCKET)/sshkey/

sshkey-get:
	@echo "Get ssh key frome S3 buckets ..."
	aws s3 cp s3://$(ACCOUNT_S3_BUCKET)/sshkey/sshkey_$(STACK) local_sshkey_$(STACK)
	aws s3 cp s3://$(ACCOUNT_S3_BUCKET)/sshkey/sshkey_$(STACK).pub local_sshkey_$(STACK).pub

setup: check-prereq sshkeypair-setup s3bucket-setup sshkey-put

#
# Set the following environment variable prior to config, plan and apply
#  AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
#
config:
	@echo "Terraform remote S3 backend config for terraform state ..."
	terraform remote config -backend=s3 \
	  -backend-config="bucket=$(ACCOUNT_S3_BUCKET)" \
	  -backend-config="key=$(TFSTATE_FILE)" \
	  -backend-config="encrypt=1"

plan: config sshkey-get
	@echo "Terraform get, plan ..."
	terraform get
	terraform plan

deploy: config
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform apply started ..."
	terraform apply
	rm -f .terraform/terraform.tfstate*
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform apply done ..."

output: config
	terraform show
	rm -f .terraform/terraform.tfstate*

destroy: plan
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform destroy started ..."
	terraform destroy
	rm -rf .terraform
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform destroy done ..."
