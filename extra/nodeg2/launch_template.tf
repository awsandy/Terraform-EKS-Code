resource "aws_launch_template" "lt-ng2" {
  #instance_type          = "t3a.small"
  key_name               = data.terraform_remote_state.iam.outputs.key_name
  name                   = format("at-lt-%s-ng2", data.aws_eks_cluster.eks_cluster.name)
  tags                   = {}
  image_id               = data.aws_ssm_parameter.eksami.value
  #user_data              = base64encode(local.eks-node-private-userdata)
  user_data = data.cloudinit_config.example.rendered
  vpc_security_group_ids = [data.terraform_remote_state.net.outputs.allnodes-sg]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = format("%s-ng2", data.aws_eks_cluster.eks_cluster.name)
    }
  }
  lifecycle {
    create_before_destroy = true
  }

}


  #block_device_mappings {
  #  device_name = "/dev/sda1"

  #  ebs {
  #    volume_size = 20
  #    volume_type = "gp3"
  #  }
  #}

