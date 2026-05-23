terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  required_version = ">=1.15.4"
}

provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "web" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}

# create a VPC
/* resource "aws_pc" "example"{
    cidr_block = "10.0.0.0/16"
} */