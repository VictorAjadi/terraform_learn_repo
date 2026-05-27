terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">=1.15.4"
}

provider "aws" {
  region = "us-east-1"
}

# EC2 Instance
resource "aws_instance" "Terraform_EC2" {
  ami                         = "ami-091138d0f0d41ff90"
  instance_type               = "t2.micro"

  provisioner "local-exec" {
    command = "touch victor-ajadi.txt"
  }
  tags = {
    Name = "Terraform_EC2"
  }
}