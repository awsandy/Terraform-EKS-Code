test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || "echo AWS_REGION is not set && exit"
test -n "$ACCOUNT_ID" && echo ACCOUNT_ID is "$ACCOUNT_ID" || "echo ACCOUNT_ID is not set && exit"
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
#docker pull alexwhen/docker-2048
#docker tag docker-2048 aws_account_id.dkr.ecr.region.amazonaws.com/docker-2048
dirs="nginx busybox"
for i in $dirs; do
docker pull $i
docker tag $i $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$i
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$i
done

docker pull amazon/aws-cli 
docker tag amazon/aws-cli $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-cli
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/aws-cli

docker pull public.ecr.aws/awsandy/docker-2048 
docker tag public.ecr.aws/awsandy/docker-2048 $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sample-app
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sample-app

# karpenter stuff 
docker pull public.ecr.aws/karpenter/controller
docker pull public.ecr.aws/karpenter/webhook
docker tag public.ecr.aws/karpenter/webhook $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/karpenter/webhook
docker tag public.ecr.aws/karpenter/controller $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/karpenter/controller
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/karpenter/webhook
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/karpenter/controller
docker pull public.ecr.aws/eks-distro/kubernetes/pause
docker tag public.ecr.aws/eks-distro/kubernetes/pause $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/pause
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/pause