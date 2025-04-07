output "iam_role_arn" {
  description = "The ARN of the IAM role created for the service account"
  value       = aws_iam_role.irsa.arn
}

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.irsa.name
}
