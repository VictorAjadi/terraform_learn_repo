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

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public subnet"
  }
}

# Security Group
resource "aws_security_group" "allow_ssh_tls" {
  name        = "allow_ssh_tls"
  description = "Allow SSH and TLS inbound traffic, all outbound"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_ssh_tls"
  }
}

# Allow SSH (22) from anywhere
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Allow HTTPS (443) from VPC CIDR
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# Allow all outbound
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Key Pair
resource "aws_key_pair" "deployer" {
  key_name   = "deployer_key"
  public_key = file("/home/user/.ssh/deployer_key.pub")
}

# EC2 Instance
resource "aws_instance" "Terraform_EC2" {
  ami                         = "ami-091138d0f0d41ff90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_ssh_tls.id]

  # Attach the key pair
  key_name = aws_key_pair.deployer.key_name

  provisioner "file" {
    source      = "/home/user/test-file.txt"
    destination = "/home/ubuntu/test-file.txt"
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/home/user/.ssh/deployer_key")
    timeout     = "4m"
  }
}