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