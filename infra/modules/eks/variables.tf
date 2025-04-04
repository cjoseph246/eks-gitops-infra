variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources into"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
}

variable "aws_auth_users" {
  description = "IAM users to be added to aws-auth configmap"
  type        = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks to allow public access to the EKS control plane"
  type        = list(string)
  default     = []
}