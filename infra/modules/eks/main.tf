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

  manage_aws_auth_configmap = true
  aws_auth_users = var.aws_auth_users
}

terraform {
  backend "s3" {}
}