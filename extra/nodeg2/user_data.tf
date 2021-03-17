locals {
  eks-node-private-userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
sudo /etc/eks/bootstrap.sh --apiserver-endpoint '${data.aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${data.aws_eks_cluster.eks_cluster.certificate_authority[0].data}' '${data.aws_eks_cluster.eks_cluster.name}'
echo "Running custom user data script" > /tmp/me.txt
yum install -y amazon-ssm-agent amazon-cloudwatch-agent iptables-services
echo "yum'd agent" >> /tmp/me.txt
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent 
inst=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# disable meta data
#iptables --insert FORWARD 1 --in-interface eni+ --destination 169.254.169.254/32 --jump DROP
#systemctl enable --now iptables
#iptables-save | tee /etc/sysconfig/iptables 
#


#/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux
--==MYBOUNDARY==--
USERDATA
}