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
resource "aws_instance" "ec2_server_2" {
  ami = data.aws_ami.ec2_ami.id
  instance_type = "t2.micro"

  tags = {
    Name = "server_2"
  }
}