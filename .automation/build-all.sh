rm -f build.log
date >> build.log
cur=`pwd`
buildok=1
dirs="tfinit net iam c9net cluster nodeg cicd eks-cidr lb2 sampleapp extra/nodeg2 extra/eks-cidr2 extra/sampleapp2 fargate"
./build-stage.sh tfinit >> build.log
./build-stage.sh Launch/net >> build.log
./build-stage.sh Launch/iam >> build.log
./build-stage.sh Launch/c9net >> build.log
./build-stage.sh Launch/cluster >> build.log
./build-stage.sh Launch/nodeg >> build.log
./build-stage.sh Launch/lb2 >> build.log
./build-stage.sh Beginner/eks-cidr >> build.log
./build-stage.sh Intermediate/cicd >> build.log
./build-stage.sh Intermediate/sampleapp >> build.log
./build-stage.sh Beginner/fargate >> build.log
./build-stage.sh Beginner/fargate/fargateapp >> build.log
./build-stage.sh extra/nodeg2 >> build.log
./build-stage.sh extra/eks-cidr2 >> build.log
./build-stage.sh extra/sampleapp2 >> build.log
date >> build.log
