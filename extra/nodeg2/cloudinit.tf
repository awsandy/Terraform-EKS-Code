locals {
  cloud_config_config = <<-END
    #cloud-config
    ${jsonencode({
      write_files = [
        {
          path        = "/opt/aws/amazon-cloudwatch-agent/bin/config.json"
          permissions = "0644"
          owner       = "root:root"
          encoding    = "b64"
          content     = filebase64("cw-config.json")
        },
      ]
    })}
  END
}


data "cloudinit_config" "example" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config.yaml"
    content      = local.cloud_config_config
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "example.sh"
    content  = <<-EOF
    #!/bin/bash -xe
    sudo /etc/eks/bootstrap.sh --apiserver-endpoint '${data.aws_eks_cluster.eks_cluster.endpoint}' --b64-cluster-ca '${data.aws_eks_cluster.eks_cluster.certificate_authority[0].data}' '${data.aws_eks_cluster.eks_cluster.name}'
    echo "Running custom user data script" > /tmp/me.txt
    yum install -y amazon-ssm-agent amazon-cloudwatch-agent iptables-services
    echo "yum'd agent" >> /tmp/me.txt
    systemctl enable amazon-ssm-agent && systemctl start amazon-ssm-agent 
    inst=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    echo $inst >> /tmp/me.txt
    EOF
  }
}