data "aws_ami" "ec2_ami" {
    most_recent      = true
    owners           = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-ecs*"]
    # for Amazon Linux 2023 - the name starts with al2023-ami-2023*
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
    # ebs - instance store
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
    # hvm, paravirtual
  }
}
 
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

resource "aws_instance" "Terraform EC2" {
  ami = data.aws_ami.ec2_ami.id
  instance_type = var.instance_type

  tags = {
    Name = "Terraform_EC2"
  }
}