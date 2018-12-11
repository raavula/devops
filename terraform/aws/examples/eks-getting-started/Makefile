ACCOUNT_S3_BUCKET = raghav-eks-state
TFSTATE_FILE   = terraform.state


.PHONY: check-prereq setup config plan deploy

check-prereq:
	@echo "check pre-requisites ..."
	command -v terraform >/dev/null 2>&1 || { echo "terraform is not in PATH.  Aborting." >&2; exit 1; }
	command -v aws >/dev/null 2>&1 || { echo "terraform is not in PATH.  Aborting." >&2; exit 1; }

s3bucket-setup:
	@echo "Create S3 buckets ..."
	aws s3api create-bucket --bucket $(ACCOUNT_S3_BUCKET) --region us-east-1

setup: check-prereq s3bucket-setup

#
# Set the following environment variable prior to config, plan and apply
#  AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
#
config:
	@echo "Terraform remote S3 backend config for terraform state ..."

plan: config
	@echo "Terraform get, plan ..."
	terraform init
	terraform get
	terraform plan

deploy: config
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform apply started ..."
	terraform apply
	rm -f .terraform/terraform.tfstate*
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform apply done ..."

output: config
	terraform init 
	terraform show
	rm -f .terraform/terraform.tfstate*

destroy: plan
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform destroy started ..."
	terraform destroy
	rm -rf .terraform
	@echo "`date +%Y-%m-%dT%H:%M:%S%z`: Terraform destroy done ..."
