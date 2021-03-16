rm -f build.log
date >> build.log
cur=`pwd`
buildok=1
dirs="tfinit Launch/net Launch/iam Launch/c9net Launch/cluster Launch/nodeg Launch/lb2  Beginner/eks-cidr Intermediate/cicd Intermediate/sampleapp extra/nodeg2 extra/eks-cidr2 extra/sampleapp2 Beginner/fargate  Beginner/irsa"
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

