echo "Install OS tools"
sudo yum -y -q -e 0 install  jq moreutils nmap > /dev/null
echo "Update OS tools"
sudo yum update -y > /dev/null
echo "Update pip"
sudo pip install --upgrade pip 2&> /dev/null
echo "Uninstall AWS CLI v1"
sudo /usr/local/bin/pip uninstall awscli -y 2&> /dev/null
sudo pip uninstall awscli -y 2&> /dev/null
echo "Install AWS CLI v2"
curl --silent "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" > /dev/null
unzip -qq awscliv2.zip
sudo ./aws/install > /dev/null
rm -f awscliv2.zip
rm -rf aws

# setup for AWS cli
aws sts get-caller-identity --query Arn | grep eksworkshop-admin > /dev/null
if [ $? -eq 0 ]; then
  rm -vf ${HOME}/.aws/credentials
  export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
  export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
  test -n "$AWS_REGION" && echo AWS_REGION is "$AWS_REGION" || echo AWS_REGION is not set !!
  echo "export ACCOUNT_ID=${ACCOUNT_ID}" | tee -a ~/.bash_profile
  echo "export AWS_REGION=${AWS_REGION}" | tee -a ~/.bash_profile
  export TF_VAR_region=${AWS_REGION}
  echo "export TF_VAR_region=${AWS_REGION}" | tee -a ~/.bash_profile
  aws configure set default.region ${AWS_REGION}
  aws configure get region
fi

echo "Setup Terraform cache"
if [ ! -f $HOME/.terraform.d/plugin-cache ];then
  mkdir -p $HOME/.terraform.d/plugin-cache
  cp tfinit/dot-terraform.rc $HOME/.terraformrc
fi
echo "Setup kubectl"
if [ ! `which kubectl 2> /dev/null` ]; then
  echo "Install kubectl"
  curl --silent -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl  > /dev/null
  chmod +x ./kubectl
  sudo mv ./kubectl  /usr/local/bin/kubectl > /dev/null
  kubectl completion bash >>  ~/.bash_completion
fi

if [ ! `which eksctl 2> /dev/null` ]; then
echo "install eksctl"
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp   > /dev/null
sudo mv -v /tmp/eksctl /usr/local/bin > /dev/null
echo "eksctl completion"
eksctl completion bash >> ~/.bash_completion
fi

if [ ! `which helm 2> /dev/null` ]; then
  echo "helm"
  wget -q https://get.helm.sh/helm-v3.5.4-linux-amd64.tar.gz > /dev/null
  tar -zxf helm-v3.5.4-linux-amd64.tar.gz
  sudo mv linux-amd64/helm /usr/local/bin/helm > /dev/null
  rm -rf helm-v3.5.4-linux-amd64.tar.gz linux-amd64
fi
echo "add helm repos"
helm repo add eks https://aws.github.io/eks-charts

if [ ! `which kubectx 2> /dev/null` ]; then
  echo "kubectx"
  sudo git clone -q https://github.com/ahmetb/kubectx /opt/kubectx > /dev/null
  sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
  sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
fi


echo "ssh key"
if [ ! -f ~/.ssh/id_rsa ]; then
  mkdir -p ~/.ssh
  ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ""
  chmod 600 ~/.ssh/id*
fi

echo "ssm cli add on"
curl --silent "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/linux_64bit/session-manager-plugin.rpm" -o "session-manager-plugin.rpm"
sudo yum install -y session-manager-plugin.rpm > /dev/null
rm -f ~/environment/session-manager-plugin.rpm

echo "install tfsec ..."
wget -q https://github.com/aquasecurity/tfsec/releases/download/v0.56.0/tfsec-linux-amd64
sudo mv tfsec-linux-amd64 /usr/bin/tfsec
sudo chmod 755 /usr/bin/tfsec 

echo "install ec2-instance-selector ..."
if [ ! `which ec2-instance-selector 2> /dev/null` ]; then
  curl --silent -Lo ec2-instance-selector https://github.com/aws/amazon-ec2-instance-selector/releases/download/v2.0.3/ec2-instance-selector-`uname | tr '[:upper:]' '[:lower:]'`-amd64 && chmod +x ec2-instance-selector
  sudo mv ec2-instance-selector /usr/bin/ec2-instance-selector
fi

# cleanup key_pair if already there
aws ec2 delete-key-pair --key-name "eksworkshop" > /dev/null

echo "pip3"
curl --silent "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py 2&> /dev/null
echo "git-remote-codecommit"
pip3 install git-remote-codecommit 2&> /dev/null

echo "Verify ...."
for command in jq aws wget kubectl terraform eksctl helm kubectx
  do
    which $command &>/dev/null && echo "$command in path" || echo "$command NOT FOUND"
  done


this=`pwd`
#echo "sample apps"
cd ~/environment

echo "Enable bash_completion"
. /etc/profile.d/bash_completion.sh
. ~/.bash_completion
echo "alias tfb='terraform init && terraform plan -out tfplan && terraform apply tfplan && terraform init -force-copy'" >> ~/.bash_profile
echo "alias aws='/usr/local/bin/aws'" >> ~/.bash_profile
source ~/.bash_profile


# ------  resize OS disk -----------

# Specify the desired volume size in GiB as a command-line argument. If not specified, default to 20 GiB.
VOLUME_SIZE=${1:-32}

# Get the ID of the environment host Amazon EC2 instance.
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data//instance-id)

# Get the ID of the Amazon EBS volume associated with the instance.
VOLUME_ID=$(aws ec2 describe-instances \
  --instance-id $INSTANCE_ID \
  --query "Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId" \
  --output text)

# Resize the EBS volume.
aws ec2 modify-volume --volume-id $VOLUME_ID --size $VOLUME_SIZE

# Wait for the resize to finish.
while [ \
  "$(aws ec2 describe-volumes-modifications \
    --volume-id $VOLUME_ID \
    --filters Name=modification-state,Values="optimizing","completed" \
    --query "length(VolumesModifications)"\
    --output text)" != "1" ]; do
sleep 1
done

if [ $(readlink -f /dev/xvda) = "/dev/xvda" ]
then
  # Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/xvda 1
 
  # Expand the size of the file system.
  sudo resize2fs /dev/xvda1

else
  # Rewrite the partition table so that the partition takes up all the space that it can.
  sudo growpart /dev/nvme0n1 1

  # Expand the size of the file system.
  # sudo resize2fs /dev/nvme0n1p1 #(Amazon Linux 1)
  sudo xfs_growfs /dev/nvme0n1p1 #(Amazon Linux 2)
fi

test -n "$AWS_REGION" && echo "PASSED: AWS_REGION is $AWS_REGION" || echo AWS_REGION is not set !!
test -n "$TF_VAR_region" && echo "PASSED: TF_VAR_region is $TF_VAR_region" || echo TF_VAR_region is not set !!
test -n "$ACCOUNT_ID" && echo "PASSED: ACCOUNT_ID is $ACCOUNT_ID" || echo ACCOUNT_ID is not set !!
echo "setup tools run" >> ~/setup-tools.log

cd ~/environment/tfekscode/Launch/lb2
curl -o iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json -s

cd $this
#
# final checks
#
echo "Checking workshop setup ..."
ip=`aws ec2 describe-iam-instance-profile-associations --filters "Name=instance-id,Values=$INSTANCE_ID" | jq .IamInstanceProfileAssociations[0].IamInstanceProfile.Arn | cut -f2 -d'/' | tr -d '"'`
#echo $ip
if [ "$ip" != "eksworkshop-admin" ] ; then
echo "ERROR: Could not find Instance profile eksworkshop-admin! - DO NOT PROCEED exiting"
exit
else
echo "PASSED: Found Instance profile eksworkshop-admin - proceed with the workshop"
fi
aws sts get-caller-identity --query Arn | grep eksworkshop-admin -q && echo "PASSED: IAM role valid - eksworkshop-admin" || echo "ERROR: IAM role not valid - DO NOT PROCEED"
iname=$(aws ec2 describe-tags --filters "Name=resource-type,Values=instance" "Name=resource-id,Values=$INSTANCE_ID" | jq -r '.Tags[] | select(.Key=="Name").Value')
echo $iname| grep eks-terraform -q && echo "PASSED: Cloud9 IDE name is valid - contains eks-terraform" || echo "ERROR: Cloud9 IDE name invalid! - DO NOT PROCEED"

