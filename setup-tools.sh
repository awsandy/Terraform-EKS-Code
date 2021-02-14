echo "Install OS tools"
sudo yum -y -q -e 0 install  jq moreutils bash-completion nmap > /dev/null

aws --version > /dev/null
if [ $? -ne 0 ]; then
  echo "Install aws cli"
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip -qq awscliv2.zip
  sudo ./aws/install
  rm -f awscliv2.zip
  rm -rf aws
else
  av=$(aws --version | cut -f2 -d '/' | cut -f1 -d'.')
  if [ $av != "2" ];then 
    echo "Update aws cli"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -qq awscliv2.zip
    sudo ./aws/install
    rm -f awscliv2.zip
    rm -rf aws

  fi
fi

# setup for AWS cli
aws sts get-caller-identity --query Arn | grep eksworkshop-admin > /dev/null
if [ $? -eq 0 ]; then
  rm -vf ${HOME}/.aws/credentials
  export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
  export TF_VAR_region=$(echo $AWS_REGION)
  export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
  test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set !!
  echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
  echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
  export TF_VAR_region=${AWS_REGION}
  echo "export TF_VAR_region=${AWS_REGION}" | tee -a ~/.bash_profile
  aws configure set default.region ${AWS_REGION}
  aws configure get region
fi


if [ ! `which terraform 2> /dev/null` ]; then
  echo "Install Terraform"
  wget https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip
  unzip -qq terraform_0.14.5_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  rm -f terraform_0.14.5_linux_amd64.zip
fi

if [ ! -f $HOME/.terraform.d/plugin-cache ];then
  mkdir -p $HOME/.terraform.d/plugin-cache
  cp tfinit/dot-terraform.rc $HOME/.terraformrc
fi

if [ ! `which kubectl 2> /dev/null` ]; then
  echo "Install kubectl"
  curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl  /usr/local/bin/kubectl
  kubectl completion bash >>  ~/.bash_completion
fi

if [ ! `which eksctl 2> /dev/null` ]; then
echo "install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv -v /tmp/eksctl /usr/local/bin
echo "eksctl completion"
eksctl completion bash >> ~/.bash_completion
fi

if [ ! `which helm 2> /dev/null` ]; then
  echo "helm"
  wget https://get.helm.sh/helm-v3.5.1-linux-amd64.tar.gz
  tar -zxf helm-v3.5.1-linux-amd64.tar.gz
  sudo mv linux-amd64/helm /usr/local/bin/helm
  rm -rf helm-v3.5.1-linux-amd64.tar.gz linux-amd64
fi
echo "add helm repos"
helm repo add eks https://aws.github.io/eks-charts

if [ ! `which kubectx 2> /dev/null` ]; then
  echo "kubectx"
  sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
fi



echo "ssh key"
if [ ! -f ~/.ssh/id_rsa ]; then
  mkdir -p ~/.ssh
  ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
  chmod 600 ~/.ssh/id*
fi
aws ec2 delete-key-pair --key-name "eksworkshop" > /dev/null
aws ec2 import-key-pair --key-name "eksworkshop" --public-key-material fileb://~/.ssh/id_rsa.pub > /dev/null
echo "KMS key"
aws kms create-alias --alias-name alias/eksworkshop --target-key-id $(aws kms create-key --query KeyMetadata.Arn --output text)
export MASTER_ARN=$(aws kms describe-key --key-id alias/eksworkshop --query KeyMetadata.Arn --output text)
if [ ! -z $MASTER_ARN ];then
echo "export MASTER_ARN=${MASTER_ARN}" | tee -a ~/.bash_profile
fi

echo "git-remote-codecommit"
pip install git-remote-codecommit > /dev/null

echo "Verify ...."
for command in jq aws wget kubectl terraform eksctl helm kubectx
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done


this=`pwd`
#echo "sample apps"
cd ~/environment
#git clone https://github.com/brentley/ecsdemo-frontend.git
#git clone https://github.com/brentley/ecsdemo-nodejs.git
#git clone https://github.com/brentley/ecsdemo-crystal.git
#git clone https://github.com/aws-samples/aws2tf.git
echo "Enable bash_completion"
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
source ~/.bash_profile

#aws --version
#eksctl version
#Install  version --client
#helm version
test -n "$AWS_REGION" && echo "PASSED: AWS_REGION is $AWS_REGION" || echo AWS_REGION is not set !!
test -n "$ACCOUNT_ID" && echo "PASSED: ACCOUNT_ID is $ACCOUNT_ID" || echo ACCOUNT_ID is not set !!
cd $this
