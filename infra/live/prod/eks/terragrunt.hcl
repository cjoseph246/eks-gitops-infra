include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/eks"
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  aws_region    = "us-east-1"
  vpc_id        = dependency.vpc.outputs.vpc_id
  subnet_ids    = dependency.vpc.outputs.private_subnets
  cluster_name  = "eks-cluster"
  cluster_version = "1.32"

  manage_aws_auth_configmap = false
  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::062989738166:role/eks-cluster-cluster-20250404183045393700000005"
      username = "eks-admin"
      groups   = ["system:masters"]
    }
  ]
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::062989738166:user/Chuck"
      username = "Chuck"
      groups   = ["system:masters"]
    }
  ]
  public_access_cidrs = ["0.0.0.0/0"]
}