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
    type: ClusterIP
  ingress:
    enabled: true
    ingressClassName: alb
    annotations:
      kubernetes.io/ingress.class: alb
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    hosts:
      - argocd.prod.com
    paths:
      - /
EOF
}

variable "enable_app_of_apps" {
  description = "Whether to deploy the App of Apps root ArgoCD Application"
  type        = bool
  default     = false
}
