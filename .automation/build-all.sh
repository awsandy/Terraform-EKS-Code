rm -f build.log
date >> build.log
cur=`pwd`
buildok=1
dirs="tfinit Launch/net Launch/iam Launch/c9net Launch/cluster Launch/nodeg Launch/lb2  Beginner/eks-cidr Intermediate/cicd Intermediate/sampleapp extra/nodeg2 extra/eks-cidr2 extra/sampleapp2 Beginner/fargate Beginner/fargate/fargateapp"
for i in `echo $dirs`;do
    echo $i
    ./build-stage.sh $i 2>&1 | tee -a build.log
    grep Error: build.log
    if [[ $? -eq 0 ]];then
        echo "Error: in build.log"
        exit
    fi
done
date >> build.log
exit
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

