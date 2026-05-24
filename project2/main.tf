/* 
1. create a vpc in us-east-1, CIDR 10.0.0.0/16
2. create a subnet with the CIDR 10.0.2.0/24 into the above VPC
3. create an s3 bucket in the same region
 */

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


resource "aws_vpc" "lab_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "custom_vpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.lab_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "lab subnet"
  }
}

resource "aws_s3_bucket" "lab_s3" {
  bucket = "lab-storage-vpc"
  region = "us-east-1"
  tags = {
    Name        = "My bucket"
  }
}