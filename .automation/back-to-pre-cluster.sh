date
echo "Pre cli based actions ..."
userid=$(aws iam list-service-specific-credentials --user-name git-user | jq -r .ServiceSpecificCredentials[0].ServiceSpecificCredentialId)
if [ "$userid" != "null" ]; then
echo "destroying git user credentails for $userid"
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

echo "circa 25 minutes..."
echo "pass 1 ...."
cur=`pwd`
date
dirs="Beginner/fargate/fargateapp Beginner/irsa Advanced/app-mesh Beginner/fargate extra/sampleapp2 extra/eks-cidr2 extra/nodeg2 Intermediate/sampleapp Launch/lb2 Launch/cicd Beginner/eks-cidr Launch/nodeg Launch/cluster"
for i in $dirs; do
cd $cur
cd ../$i
echo "**** Destroying in $i ****"
rm -rf .terrform* backend.tf
terraform init -no-color -force-copy -lock=false > /dev/null
terraform destroy -auto-approve -lock=false -no-color
rc=$(terraform state list | wc -l)
if [ $rc -gt 0 ];then
    echo "**** Unexpected resources left in state exit ...."
    exit
fi
rm -f terraform.tfstate* tfplan 
cd $cur
date
done
echo "Done"

exit