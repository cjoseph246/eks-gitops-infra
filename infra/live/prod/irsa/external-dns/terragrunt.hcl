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
  name                 = "external-dns-irsa"
  namespace            = "kube-system"
  service_account_name = "external-dns"

  oidc_provider_url = dependency.eks.outputs.oidc_provider_url
  oidc_provider_arn = dependency.eks.outputs.oidc_provider_arn

  tags = {
    Name        = "External DNS IRSA"
    Environment = "prod"
  }
}
