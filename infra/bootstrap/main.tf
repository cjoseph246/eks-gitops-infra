provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "tf_state" {
  bucket = "tf-state-${data.aws_caller_identity.current.account_id}"

  tags = {
    Name        = "TF State Bucket"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "TF Lock Table"
    Environment = "prod"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}
