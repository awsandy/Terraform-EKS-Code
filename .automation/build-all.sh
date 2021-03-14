date
cur=`pwd`
buildok=1
dirs="tfinit net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp extra/nodeg2 extra/eks-cidr2 extra/sampleapp2 fargate"
./build-stage.sh tfinit
./build-stage.sh Launch/net
./build-stage.sh Launch/iam
./build-stage.sh Launch/c9net
./build-stage.sh Launch/cluster
./build-stage.sh Launch/nodeg
./build-stage.sh Launch/lb2
./build-stage.sh Beginner/eks-cidr
./build-stage.sh Intermediate/cicd
./build-stage.sh Intermediate/sampleapp
./build-stage.sh Beginner/fargate
./build-stage.sh Beginner/fargate/fargateapp
./build-stage.sh extra/nodeg2
./build-stage.sh extra/eks-cidr2 
./build-stage.sh extra/sampleapp2
date

