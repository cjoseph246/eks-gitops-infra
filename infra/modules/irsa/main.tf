provider "aws" {
  region = var.aws_region
}

resource "aws_iam_role" "irsa" {
  name = var.name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${var.oidc_provider_url}:sub" = "system:serviceaccount:${var.namespace}:${var.service_account_name}"
          }
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  count  = var.name == "aws-load-balancer-controller-irsa" ? 1 : 0
  name   = "AWSLoadBalancerControllerIAMPolicy"
  path   = "/"
  policy = file("${path.module}/policies/aws-load-balancer-controller.json")
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  count      = var.name == "aws-load-balancer-controller-irsa" ? 1 : 0
  policy_arn = aws_iam_policy.aws_load_balancer_controller[0].arn
  role       = aws_iam_role.irsa.name
}

resource "aws_iam_policy" "external_dns" {
  count  = var.name == "external-dns-irsa" ? 1 : 0
  name   = "ExternalDNSPolicy"
  path   = "/"
  policy = file("${path.module}/policies/external-dns.json")
}

resource "aws_iam_role_policy_attachment" "external_dns_attach" {
  count      = var.name == "external-dns-irsa" ? 1 : 0
  policy_arn = aws_iam_policy.external_dns[0].arn
  role       = aws_iam_role.irsa.name
}

terraform {
  backend "s3" {}
}