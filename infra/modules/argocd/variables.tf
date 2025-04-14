variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources into"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "argocd_helm_values" {
  description = "Override Helm values for ArgoCD installation"
  type        = string
  default     = <<EOF
server:
  service:
    type: LoadBalancer
  ingress:
    enabled: false
EOF
}

variable "enable_app_of_apps" {
  description = "Whether to deploy the App of Apps root ArgoCD Application"
  type        = bool
  default     = false
}
