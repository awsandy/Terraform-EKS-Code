locals {
  eks-node-private-userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
sudo /etc/eks/bootstrap.sh --apiserver-endpoint '${data.aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${data.aws_eks_cluster.eks_cluster.certificate_authority[0].data}' '${data.aws_eks_cluster.eks_cluster.name}'
echo "Running custom user data script" > /tmp/me.txt
yum install -y amazon-ssm-agent awslogs amazon-cloudwatch-agent iptables-services
echo "yum'd agent" >> /tmp/me.txt
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent 
inst=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
# disable meta data
#iptables --insert FORWARD 1 --in-interface eni+ --destination 169.254.169.254/32 --jump DROP
#systemctl enable --now iptables
#iptables-save | tee /etc/sysconfig/iptables 
#
# CW logs
cat <<EOF > /etc/awslogs/awslogs.conf
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = myeks/MYINST/var/log/dmesg
log_stream_name = myeks

[/var/log/messages]
file = /var/log/messages
log_group_name = myeks/MYINST/var/log/messages
log_stream_name = myeks
datetime_format = %b %d %H:%M:%S

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log
log_group_name = myeks/MYINST/var/log/ecs/ecs-init
log_stream_name = myeks
datetime_format = %Y-%m-%dT%H:%M:%SZ
EOF

sed -i 's/MYINST/${myinst}/g' /etc/awslogs/awslogs.conf
cat <<EOF > /etc/awslogs/awscli.conf
[plugins]
cwlogs = cwlogs
[default]
region = eu-west-1
EOF
systemctl enable awslogsd.service
systemctl start awslogsd

# git clone something /opt/aws/amazon-cloudwatch-agent/bin/config.json
# or aws s3 cp /opt/aws/amazon-cloudwatch-agent/bin/config.json
#/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
#/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a start
date >> /tmp/me.txt

--==MYBOUNDARY==--
USERDATA
}