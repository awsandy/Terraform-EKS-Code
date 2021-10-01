# TF_VAR_region
variable "region" {
  description = "The name of the AWS Region"
  type        = string
  default     = "eu-west-1"
}

variable "profile" {
  description = "The name of the AWS profile in the credentials file"
  type        = string
  default     = "default"
}

variable "cluster-name" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "mycluster1"
}

variable "eks_version" {
  type    = string
  default = "1.21"
}

variable "no-output" {
  description = "The name of the EKS Cluster"
  type        = string
  default     = "secret"
  sensitive   = true
}

variable "cidr_block" {
  type        = string
  default     = "10.0.0.0/20"
  description = "The CIDR block for the VPC."
}

variable "cidr_block2" {
  type        = string
  default     = "100.64.0.0/16"
  description = "The CIDR block for the VPC."
}




variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
  description = "The availability zones to create subnets in"
}

variable "az_counts" {
  default = 3
}

variable "spots" {
  default = ["m5.large","m5a.large",]
}


