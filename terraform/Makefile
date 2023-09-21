# Log into your AWS account or export your creds & export the rosa token
#
# export aws_access_key_id
# export aws_secret_access_key
# export AWS_DEFAULT_REGION
# export TF_VAR_token=
# 
# hash out s3 in backend providers file.
#
# providers.tf
#
# backend "s3" {
#   region  = "ap-southeast-2"
#   encrypt = true
# }
# run make init\make plan\make apply\make destroy

AWS_DEFAULT_REGION=ap-southeast-4
WORKSPACE=nonprod-dev
VARS=clusters/cluster2-nonprod-public.tfvars.json

init: 
	terraform init -input=false -lock=false -no-color -reconfigure 
	echo "---:init: Selecting Terraform workspace $(WORKSPACE)"
	terraform workspace new $(WORKSPACE) 2>/dev/null; true
	terraform workspace "select" $(WORKSPACE)
.PHONY: init

plan:
	terraform plan -lock=false -var-file=$(VARS) -out=.terraform-plan
.PHONY: plan

apply:
	terraform apply .terraform-plan
.PHONY: apply

destroy:
	terraform destroy -auto-approve -input=false  -var-file=$(VARS)
.PHONY: destroy

output:
	terraform output > tf-output-parameters
.PHONY: output


