rm -f backend.tf .tfph1
echo "Init away from s3"
terraform init -no-color -force-copy
echo "Destroy"
terraform destroy -no-color -auto-approve -lock=false