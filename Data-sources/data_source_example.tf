data "aws_region" "current" {
  
}

output "current_region" {
  value = data.aws_region.current.id
}

data "aws_regions" "current_regions" {
  
}

output "current_regions_names" {
  value = data.aws_regions.current_regions.names
}

data "aws_availability_zones" "available" {
}

output "available_zones" {
  value = data.aws_availability_zones.available.names[*]
}

data "aws_ami" "myami" {
  most_recent = true
  owners = ["amazon"]

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

output "fetched_ami" {
  value = data.aws_ami.myami.id
}

output "fetched_ami_name" {
  value = data.aws_ami.myami.name
}

resource "aws_instance" "server" {
  ami = data.aws_ami.myami.id
  instance_type = "t2.micro"
}