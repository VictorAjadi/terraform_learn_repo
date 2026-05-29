terraform {
  source = "tfr:///terraform-aws-modules/ec2-instance/aws?version=6.4.0"
}

locals {
  env_vars = yamldecode(
    file("${find_in_parent_folders("common-environment.yaml")}")
  )
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region                   = "us-east-1"
  profile                  = "default"
  shared_credentials_files = ["~/.aws/credentials"]
}
EOF
}

inputs = {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = local.env_vars.instance_type

  # Add your subnet ID here to avoid the "multiple subnets matched" error
  subnet_id     = "subnet-0f47ead8c6bb4365c" # replace with your actual subnet ID

  tags = {
    Name = "Terragrunt Tutorial: EC2"
  }
}