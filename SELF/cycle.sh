rm -f backend.tf .tfph1
echo "Init away from s3"
terraform init -no-color -force-copy
echo "Destroy"
terraform destroy -no-color -auto-approve
terraform init -no-color
echo "Plan"
terraform plan -out tfplan -no-color
echo "Apply"
terraform apply tfplan -no-color
#echo "2nd Plan"
#terraform plan -out tfplan -no-color
#echo "2nd Apply"
#terraform apply tfplan -no-color