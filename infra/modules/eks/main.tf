module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.35"

  cluster_name    = "eks-cluster"
  cluster_version = "1.31"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      desired_size = 3
      max_size     = 3
      min_size     = 2

      instance_types = ["m6a.large", "t3.large"]
      ami_type = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"
    }
  }

  tags = {
    environment = "prod"
  }
}
