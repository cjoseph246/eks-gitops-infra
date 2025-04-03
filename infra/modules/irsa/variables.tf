variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "service_account_name" {
  type = string
}

variable "oidc_provider_url" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources into"
}