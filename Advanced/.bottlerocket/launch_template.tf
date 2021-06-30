locals {
 instance_profile_arn = data.terraform_remote_state.iam.outputs.nodegroup_role_ar
 root_device_mappings = tolist(data.aws_ami.bottlerocket_image.block_device_mappings)[0]
 autoscaler_tags      = var.cluster_autoscaler ? { "k8s.io/cluster-autoscaler/enabled" = "true", "k8s.io/cluster-autoscaler/${var.cluster-name}" = "owned" } : {}
 bottlerocket_tags    = { "Name" = "eks-node-aws_eks_cluster.cluster.name" }
 tags                 = merge(var.tags, { "kubernetes.io/cluster/${var.cluster-name}" = "owned"}, local.autoscaler_tags, local.bottlerocket_tags)
 labels = merge(
    var.labels
 )
}

data "template_file" "bottlerocket_config" {
  template = file("bottlerocket_config.toml.tpl")
  vars = {
    cluster_name                 = data.terraform_remote_state.cluster.outputs.cluster-name
    cluster_endpoint             = data.terraform_remote_state.cluster.outputs.endpoint
    cluster_ca_data              = data.terraform_remote_state.cluster.outputs.ca
    node_labels                  = join("\n", [for label, value in local.labels : "\"${label}\" = \"${value}\""])
    node_taints                  = join("\n", [for taint, value in var.taints : "\"${taint}\" = \"${value}\""])
    admin_container_enabled      = true
    admin_container_superpowered = true
    admin_container_source       = var.bottlerocket_admin_source
  }
}

data "aws_ssm_parameter" "bottlerocket_image_id" {
  name = "/aws/service/bottlerocket/aws-k8s-${var.eks_version}/x86_64/latest/image_id"
}

data "aws_ami" "bottlerocket_image" {
  owners = ["amazon"]
  filter {
    name   = "image-id"
    values = [data.aws_ssm_parameter.bottlerocket_image_id.value]
  }
}


resource "aws_launch_template" "bottlerocket_lt" {
  name_prefix            = var.name
  update_default_version = true
  block_device_mappings {
    device_name = local.root_device_mappings.device_name

    ebs {
      volume_size           = var.root_volume_size
      volume_type           = local.root_device_mappings.ebs.volume_type
      delete_on_termination = true
    }
  }

  instance_type = var.instance_size

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
  }

   image_id      = data.aws_ami.bottlerocket_image.id 
   user_data     = base64encode(data.template_file.bottlerocket_config.rendered)

 tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags          = local.tags
  }
  tags = local.tags

 key_name = var.key_name

  lifecycle {
    create_before_destroy = true
  }
}
