variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources into"
}

variable "cluster_name" {
  description = "Name of the EKS cluster used for subnet tagging"
  type        = string
}