terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>6.0"
    }
  }
  required_version = ">=1.15.4"
}

provider "aws" {
  region = "us-east-1"
}
locals {
  ingress_rules = [
    {
        cidr_blocks         = "0.0.0.0/0"
        port              = 22
    },
    {
        cidr_blocks         = aws_vpc.main.cidr_block
        port              = 443
    }
  ]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_ssh_tls" {
  name        = "allow_ssh_tls"
  description = "Allow SSH and TLS inbound traffic, all outbound"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value.cidr_blocks]
    }
  }

  tags = {
    Name = "allow_ssh_tls"
  }
}

resource "aws_instance" "Terraform_EC2_Remote" {
  ami                         = "ami-091138d0f0d41ff90"
  instance_type               = "t2.micro"
  key_name                    = "deployer_key"
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.main.id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_tls.id]
}