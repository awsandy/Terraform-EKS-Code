rm -f backend.tf .tfph1
echo "Init away from s3"
terraform init -no-color -force-copy -lock=false
echo "Destroy"
terraform destroy -no-color -auto-approve -lock=false
terraform init -no-color
echo "Plan"
terraform plan -out tfplan -no-color
echo "Apply"
terraform apply tfplan -no-color
echo "S3 state"
terraform state list | wc -l
echo "local state"
terraform state list -state=terraform.tfstate | wc -l