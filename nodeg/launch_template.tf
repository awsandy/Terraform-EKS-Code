# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-06-05/amazon-eks-nodegroup.yaml

## updated AMI support for /etc/eks/bootstrap.sh
##

#### User data for worker launch

resource "aws_launch_template" "lt-ng-experiment2" {
  instance_type           = "t3.small"
  key_name                = "eksworkshop"
  name                    = format("at-lt-%s-experiment2", data.aws_eks_cluster.eks_cluster.name)
  tags                    = {}
  image_id                = aws_ssm_parameter.eks-ami.value
  user_data            = base64encode(local.eks-node-private-userdata)
  vpc_security_group_ids  = [data.terraform_remote_state.net.outputs.allnodes-sg] 
  tag_specifications { 
        resource_type = "instance"
    tags = {
        Name = format("%s-ng1", data.aws_eks_cluster.eks_cluster.name)
        }
    }
  lifecycle {
    create_before_destroy=true
  }
}


  #block_device_mappings {
  #  device_name = "/dev/sda1"

  #  ebs {
  #    volume_size = 20
  #  }
  #}



#resource "aws_launch_configuration" "eks-private-lc" {
#  image_id                    = "${var.eks-worker-ami}" ## visit https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html
##  iam_instance_profile        = "${aws_iam_instance_profile.eks-node.name}"
#  instance_type               = "${var.worker-node-instance_type}" # use instance variable
#  key_name                    = "${var.ssh_key_pair}"
#  name_prefix                 = "eks-private"
#  security_groups             = ["${aws_security_group.eks-node.id}"]

  
  
## Enable this when you use cluster autoscaler within cluster.
## https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/cloudprovider/aws/README.md

#  tag {
#    key                 = "k8s.io/cluster-autoscaler/enabled"
#    value               = ""
#    propagate_at_launch = true
#  }
#
#  tag {
#    key                 = "k8s.io/cluster-autoscaler/${var.cluster-name}"
#    value               = ""
#    propagate_at_launch = true
#  }


