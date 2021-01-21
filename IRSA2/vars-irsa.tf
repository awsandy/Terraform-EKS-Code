variable "namespace" {
  description = "The name of the k8s namespace"
  type        = string
  default     = "default"
}

variable "sa-name" {
  description = "The name of the k8s service-account"
  type        = string
  default     = "iam-test"
}