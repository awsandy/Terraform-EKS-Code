# delete code commit repo eksworkshop-app
aws iam detach-user-policy --user-name git-user --policy-arn arn:aws:iam::aws:policy/AWSCodeCommitPowerUser
aws iam delete-user --user-name git-user
# delete ECR repo's eksworkshop-app, aws-cli, busybox, nginx, sample-app
aws ecr delete-repository --repository-name aws-cli --force
aws ecr delete-repository --repository-name busybox --force
aws ecr delete-repository --repository-name nginx --force
aws ecr delete-repository --repository-name sample-app --force

# Roles
# AWSCodePipelineServiceRole-pipe-eksworkshop-app
# codebuild-eks-cicd-build-app-service-role
# 
parn=$(aws iam list-attached-role-policies --role-name AWSCodePipelineServiceRole-pipe-eksworkshop-app --query AttachedPolicies[0].PolicyArn | jq -r .)
aws iam detach-role-policy --role-name AWSCodePipelineServiceRole-pipe-eksworkshop-app --policy-arn $parn
aws iam delete-role --role-name AWSCodePipelineServiceRole-pipe-eksworkshop-app 
parn=$(aws iam list-attached-role-policies --role-name codebuild-eks-cicd-build-app-service-role --query AttachedPolicies[0].PolicyArn | jq -r .)
aws iam detach-role-policy --role-name codebuild-eks-cicd-build-app-service-role --policy-arn $parn
parn=$(aws iam list-attached-role-policies --role-name codebuild-eks-cicd-build-app-service-role --query AttachedPolicies[0].PolicyArn | jq -r .)
aws iam detach-role-policy --role-name codebuild-eks-cicd-build-app-service-role --policy-arn $parn
parn=$(aws iam list-attached-role-policies --role-name codebuild-eks-cicd-build-app-service-role --query AttachedPolicies[0].PolicyArn | jq -r .)
aws iam detach-role-policy --role-name codebuild-eks-cicd-build-app-service-role --policy-arn $parn
aws iam delete-role --role-name codebuild-eks-cicd-build-app-service-role

# delete Policies 
# AWSCodePipelineServiceRole-pipe-eksworkshop-app
parn=$(aws iam list-policies --scope Local --query Policies[].Arn | grep AWSCodePipelineServiceRole-pipe-eksworkshop-app | tr -d ',' | jq -r .)
echo $parn
aws iam delete-policy --policy-arn $parn
# CodeBuildBasePolicy-eks-cicd-build-app
parn=$(aws iam list-policies --scope Local --query Policies[].Arn | grep CodeBuildBasePolicy-eks-cicd-build-app | tr -d ',' | jq -r .)
echo $parn
aws iam delete-policy --policy-arn $parn
# CodeBuildVpcPolicy-eks-cicd-build-app
parn=$(aws iam list-policies --scope Local --query Policies[].Arn | grep CodeBuildVpcPolicy-eks-cicd-build-app | tr -d ',' | jq -r .)
echo $parn
aws iam delete-policy --policy-arn $parn
aws codecommit delete-repository --repository-name eksworkshop-app
aws codepipeline delete-pipeline  --name pipe-eksworkshop-app
aws codebuild delete-project --name eks-cicd-build-app

