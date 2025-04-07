variable "name" {
  type        = string
  description = "Name of the IAM role to create"
}

variable "namespace" {
  type        = string
  description = "Namespace where the Kubernetes service account resides"
}

variable "service_account_name" {
  type        = string
  description = "Name of the Kubernetes service account"
}

variable "oidc_provider_url" {
  type        = string
  description = "The OIDC provider URL for the EKS cluster"
}

variable "oidc_provider_arn" {
  type        = string
  description = "The ARN of the OIDC provider"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources into"
}
