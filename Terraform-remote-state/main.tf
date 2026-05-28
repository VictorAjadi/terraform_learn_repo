terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "aws-new-bucket-victor"
    key    = "key/terraform.tfstate"
    region = "eu-north-1"
  }
  required_version = ">=1.15.4"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "ec2_example" {
  ami                         = "ami-091138d0f0d41ff90"
  instance_type               = "t2.micro"

  tags = {
    Name = "ec2_example"
  }
}