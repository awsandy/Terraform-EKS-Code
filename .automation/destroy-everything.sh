echo "Pre cli based actions ..."
userid=$(aws iam list-service-specific-credentials --user-name git-user | jq -r .ServiceSpecificCredentials[0].ServiceSpecificCredentialId)
if [ "$userid" != "null" ]; then
echo "destroying git user credentaisl for $userid"
aws iam delete-service-specific-credential --service-specific-credential-id $userid --user-name git-user
fi
# Empty codepipeline bucket ready for delete
buck=$(aws s3 ls | grep codep-tfeks | awk '{print $3}')
echo "buck=$buck"
if [ "$buck" != "" ]; then
echo "Emptying bucket $buck"
comm=$(printf "aws s3 rm s3://%s --recursive" $buck)
eval $comm
fi
#
# lb, lb sg, launch template

echo "pass 1 ...."
cur=`pwd`
date
dirs="FARGATE extra/sampleapp2 extra/eks-cidr2 extra/nodeg2 sampleapp lb2 cicd eks-cidr nodeg cluster c9net iam net"
for i in $dirs; do
cd $cur
cd ../$i
echo "**** Destroying in $i ****"
rm -rf .terrform* backend.tf
terraform init -no-color -force-copy -lock=false > /dev/null
terraform destroy -auto-approve -lock=false -no-color
rc=$(terraform state list | wc -l)
if [ $rc .gt 0 ];then
    echo "**** Unexpected resources left in state exit ...."
    exit
fi
cd $cur
date
done
echo "Pass 1 cli based actions ..."
echo "pass 2 ...."
for i in $dirs; do
cd $cur
cd ../$i
echo "**** Destroying in $i ****"
terraform destroy -auto-approve -lock=false -no-color > /dev/null
rm -f tfplan terraform*
rm -rf .terraform
cd $cur
date
done
dirs="tf-setup"
for i in $dirs; do
cd ../$i
echo "**** Destroying in $i ****"
terraform destroy -auto-approve -lock=false -no-color > /dev/null
rm -f tfplan terraform*
rm -rf .terraform
cd $cur
date
done
echo "Done"

exit