/* 
################### Output Block & depends_on meta argument #################
1. create  a VPC in us-east-1 with the local name: main. The CIDR block is 10.0.0.0/16.
2. create a security group with the local name allow_tls. the security group allow HTTS (prot 443)
inbound from the VPC CIDR block and all traffic outbound. The security group miust be in the above VPC.
3. create  a subnet with the local name Public_Subnet in the above VPC in the availablilty zone us-east-1a, the subnet CIDR
block is 10.0.1.0/24.
4. create an AWS Linux EC2 instace in the public subnet above. The instace size is 
t2.micro choose a suitable AMI for us-east-1.
5. you need to display the publc IP of the instance. However, this should not be displayed as an output until 
security group ingress role has been to aboid access issues on prt 443.
6. validate the configuration.
7. Destroy the infrastructure.
*/

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public subnet"
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0236922087fa98b6e"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet
  associate_public_ip_address = "true"
  security_groups = [aws_security_group.allow_tls.id]
  tags = {
    Name = "HelloWorld"
  }
}

output "ec2_public_ip" {
  value = aws_instance.web.public_ip
  depends_on = [ aws_vpc_security_group_ingress_rule.allow_tls_ipv4 ]
}