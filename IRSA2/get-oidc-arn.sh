#url = data.aws_eks_cluster.eks_cluster.identity.0.oidc.0.issuer
#test -n "$1" && echo CLUSTER is "$1" || echo "CLUSTER is not set" && exit
CLUSTER=$(echo $1)
clurl=$(aws eks describe-cluster --name $CLUSTER | jq -r .cluster.identity.oidc.issuer)
clurl=`echo ${clurl:8}`

INSTANCE_IDS=()
INSTANCE_IDS+=(`aws iam list-open-id-connect-providers --query 'OpenIDConnectProviderList' --output text`)
#echo $INSTANCE_IDS
# extract the security groups
for i in "${INSTANCE_IDS[@]}"
do
idp=$(aws iam get-open-id-connect-provider --open-id-connect-provider-arn $i | jq -r .Url)
#echo "clurl=$clurl  URL=$idp"
if [ "$clurl" == "$idp" ];then
echo $i
fi
done