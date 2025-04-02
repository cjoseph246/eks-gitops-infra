output "argocd_endpoint" {
  value = helm_release.argocd.status["load_balancer"]
}

