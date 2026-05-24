/* This lab creates an s3 bucket and  an AWS VPC then uses the
block to display the ARN of the S3 bucket and the ID of the VPC */

resource "aws_s3_bucket" "mys3" {
  bucket = "byker1234"
}

resource "aws_vpc" "vic_vpc" {
  cidr_block = "10.0.0.0/16"
}

output "s3_arn" {
  value = aws_s3_bucket.mys3.arn
}

output "vpc_id" {
  value = aws_vpc.vic_vpc.id
}