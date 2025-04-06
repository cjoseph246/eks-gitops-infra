provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

provider "aws" {
  region = var.aws_region
}

resource "helm_release" "argocd" {
  provider   = helm.eks
  name       = "argocd"
  namespace  = "argocd"
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "7.8.21"

  create_namespace = true

values = [
  <<EOF
server:
  service:
    type: LoadBalancer
  ingress:
    enabled: false

configs:
  cm:
    accounts.anonymous: "enabled"
    server.disable.auth: "true"
  rbac:
    policy.default: "role:readonly"
    policy.csv: |
      p, role:readonly, applications, get, *, allow
      p, role:readonly, projects, get, *, allow
      p, role:readonly, clusters, get, *, allow
      p, role:readonly, repositories, get, *, allow
      p, role:readonly, logs, get, *, allow
      g, system:anonymous, role:readonly
EOF
  ]
}

# Comment out this block the fist time running terragrunt apply
# Once Argo is up, uncomment and re-run terragrunt apply to create root-app
resource "kubernetes_manifest" "app_of_apps" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "root-app"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/cjoseph246/eks-gitops-infra.git"
        targetRevision = "HEAD"
        path           = "infra/apps/root-app"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune     = true
          selfHeal  = true
        }
        syncOptions = ["CreateNamespace=true"]
      }
    }
  }

  field_manager {
    name            = "terraform"
    force_conflicts = true
  }

  depends_on = [helm_release.argocd]
}

terraform {
  backend "s3" {}
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}
