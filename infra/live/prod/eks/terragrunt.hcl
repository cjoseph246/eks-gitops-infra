inputs = {
  aws_region    = "us-east-1"
  vpc_id        = dependency.vpc.outputs.vpc_id
  subnet_ids    = dependency.vpc.outputs.private_subnets
  cluster_name  = "eks-cluster"
  cluster_version = "1.32"

  # Manage aws-auth automatically during EKS cluster provisioning.
  # This avoids the chicken-and-egg issue of needing kubectl access to apply aws-auth.yaml manually.
  # The aws_auth_roles and aws_auth_users variables define access to the cluster post-creation.
  manage_aws_auth_configmap = true

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
