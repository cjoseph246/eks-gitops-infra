include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../../modules/irsa"
}

dependency "eks" {
  config_path = "../../eks"
}

inputs = {
  aws_region           = "us-east-1"
  name                 = "aws-load-balancer-controller-irsa"
  namespace            = "kube-system"
  service_account_name = "aws-load-balancer-controller"

  oidc_provider_url = dependency.eks.outputs.oidc_provider_url
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  attach_policy     = true
  policy_json_path  = "${get_terragrunt_dir()}/../../../../modules/irsa/policies/aws-load-balancer-controller.json"

  tags = {
    Name        = "AWS Load Balancer Controller IRSA"
    Environment = "prod"
  }
}