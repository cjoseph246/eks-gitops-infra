include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/argocd"
}

inputs = {
  aws_region   = "us-east-1"
  cluster_name = "eks-cluster"
}
