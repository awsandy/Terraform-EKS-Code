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


docker pull public.ecr.aws/karpenter/controller:v0.6.0@sha256:c4b55bafc91bcab268c7c80c98f4341fc23ab0adc29ba33e28a1f9df1ec96de5
docker pull public.ecr.aws/karpenter/webhook:v0.6.0@sha256:bce76e56b8315c7f5ebe097a738ef81e9a07f84cfdc5da1e55975ba17783d0dc