variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources into"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster used for subnet tagging"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of AZs to use"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet CIDRs"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet CIDRs"
}

variable "enable_nat_gateway" {
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  default     = true
}

variable "public_subnet_tags" {
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  type        = map(string)
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
}
