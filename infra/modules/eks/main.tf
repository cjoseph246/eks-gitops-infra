provider "aws" {
  region = var.aws_region
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.35"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  enable_irsa = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  cluster_endpoint_public_access_cidrs = var.public_access_cidrs

  eks_managed_node_groups = {
    default = {
      desired_size = 3
      max_size     = 3
      min_size     = 2

      instance_types = ["t3.large"]
      ami_type = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    environment = "prod"
  }
}

module "aws_auth" {
  source = "github.com/terraform-aws-modules/terraform-aws-eks.git//modules/aws-auth?ref=v20.35.0"

  manage_aws_auth_configmap = var.manage_aws_auth_configmap
  aws_auth_users            = var.aws_auth_users
  aws_auth_roles            = var.aws_auth_roles

  depends_on = [module.eks]
}

data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

terraform {
  backend "s3" {}
}