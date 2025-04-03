locals {
  bucket_name = trim(file(find_in_parent_folders("bucket_name.txt")), "\n")
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.bucket_name 
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
