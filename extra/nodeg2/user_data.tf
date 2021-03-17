locals {
  eks-node-private-userdata = <<USERDATA
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash -xe
sudo /etc/eks/bootstrap.sh --apiserver-endpoint '${data.aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${data.aws_eks_cluster.eks_cluster.certificate_authority[0].data}' '${data.aws_eks_cluster.eks_cluster.name}'
echo "Running custom user data script" > /tmp/me.txt
yum install -y amazon-ssm-agent awslogs amazon-cloudwatch-agent
echo "yum'd agent" >> /tmp/me.txt
systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent iptables-services
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
log_group_name = myeks/var/log/dmesg
log_stream_name = myeks

[/var/log/messages]
file = /var/log/messages
log_group_name = myeks/var/log/messages
log_stream_name = myeks
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = myeks/var/log/docker
log_stream_name = myeks
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/cloud-init-output.log]
file = /var/log/cloud-init-output.log.*
log_group_name = myeks/var/log/ecs/ecs-init.log
log_stream_name = myeks
datetime_format = %Y-%m-%dT%H:%M:%SZ


EOF
cat <<EOF > /etc/awslogs/awscli.conf
[plugins]
cwlogs = cwlogs
[default]
region = eu-west-1
EOF
systemctl enable awslogsd.service
systemctl start awslogsd

cat <<EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "agent": {
            "metrics_collection_interval": 60,
            "run_as_user": "root"
    },
    "logs": {
            "logs_collected": {
                    "files": {
                            "collect_list": [
                                    {
                                            "file_path": "/var/log/dmesg",
                                            "log_group_name": "myeks/var/log/dmesg",
                                            "log_stream_name": "myeks"
                                    },
                                    {
                                            "file_path": "/var/log/docker",
                                            "log_group_name": "myeks/var/log/docker",
                                            "log_stream_name": "myeks",
                                            "timestamp_format": "%Y-%m-%dT%H:%M:%S.%f"
                                    },
                                    {
                                            "file_path": "/var/log/cloud-init-output.log.*",
                                            "log_group_name": "myeks/var/log/cloud-init-output.log",
                                            "log_stream_name": "myeks",
                                            "timestamp_format": "%Y-%m-%dT%H:%M:%SZ"
                                    },
                                    {
                                            "file_path": "/var/log/messages",
                                            "log_group_name": "myeks/var/log/messages",
                                            "log_stream_name": "myeks",
                                            "timestamp_format": "%b %d %H:%M:%S"
                                    }
                            ]
                    }
            }
    },
    "metrics": {
            "append_dimensions": {
                    "AutoScalingGroupName": "${aws:AutoScalingGroupName}",
                    "ImageId": "${aws:ImageId}",
                    "InstanceId": "${aws:InstanceId}",
                    "InstanceType": "${aws:InstanceType}"
            },
            "metrics_collected": {
                    "collectd": {
                            "metrics_aggregation_interval": 60
                    },
                    "cpu": {
                            "measurement": [
                                    "cpu_usage_idle",
                                    "cpu_usage_iowait",
                                    "cpu_usage_user",
                                    "cpu_usage_system"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ],
                            "totalcpu": false
                    },
                    "disk": {
                            "measurement": [
                                    "used_percent",
                                    "inodes_free"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ]
                    },
                    "diskio": {
                            "measurement": [
                                    "io_time"
                            ],
                            "metrics_collection_interval": 60,
                            "resources": [
                                    "*"
                            ]
                    },
                    "mem": {
                            "measurement": [
                                    "mem_used_percent"
                            ],
                            "metrics_collection_interval": 60
                    },
                    "statsd": {
                            "metrics_aggregation_interval": 60,
                            "metrics_collection_interval": 10,
                            "service_address": ":8125"
                    },
                    "swap": {
                            "measurement": [
                                    "swap_used_percent"
                            ],
                            "metrics_collection_interval": 60
                    }
            }
    }
}
EOF
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a start
date >> /tmp/me.txt

--==MYBOUNDARY==--
USERDATA
}