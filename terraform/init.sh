export AWS_DEFAULT_REGION=ap-southeast-2
export TF_BACKEND_BUCKET=terraform-state-foster-ocm-nonprod
export TF_BACKEND_DYNAMO=terraform-lock
export WORKSPACE=nonprod-dev
export TF_BACKEND_KEY=cluster3-nonprod
export VARS=clusters/cluster2-nonprod-public.tfvars.json
terraform init -upgrade -input=false -lock=false -no-color -reconfigure \
-backend-config="dynamodb_table=$TF_BACKEND_DYNAMO" \
-backend-config="bucket=$TF_BACKEND_BUCKET" \
-backend-config="key=$TF_BACKEND_KEY"
echo "Selecting Terraform workspace $WORKSPACE"
terraform workspace new $WORKSPACE 2>/dev/null || true
terraform workspace "select" $WORKSPACE
