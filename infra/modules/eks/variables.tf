variable "tags" {
  description = "Tags to apply to EKS resources"
  type        = map(string)
  default     = {}
}

variable "node_group_name" {
  description = "Name of the default managed node group"
  type        = string
  default     = "default"
}

variable "node_group_desired_size" {
  type        = number
  default     = 3
}

variable "node_group_max_size" {
  type        = number
  default     = 3
}

variable "node_group_min_size" {
  type        = number
  default     = 2
}

variable "node_group_instance_types" {
  type        = list(string)
  default     = ["t3.large"]
}

variable "node_group_capacity_type" {
  type        = string
  default     = "ON_DEMAND"
}

variable "node_group_ami_type" {
  type        = string
  default     = "AL2_x86_64"
}

variable "manage_aws_auth_configmap" {
  type    = bool
  default = true
}

variable "aws_auth_roles" {
  description = "IAM roles to be added to aws-auth configmap"
  type        = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}