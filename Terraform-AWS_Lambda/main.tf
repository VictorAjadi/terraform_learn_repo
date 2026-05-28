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

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "lambda-role"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "aws_policy_for_terraform_iam_policy"
  path        = "/"
  description = "AWS IAM policy for managing aws lambda role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_aws_iam_policy_role" {
  name       = "attach-aws-iam-policy-role"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.policy.arn
}


# Archive a single file.
data "archive_file" "zip_python_file" {
  type        = "zip"
  source_file = "${path.module}/python/run.py"   # point to a single file
  output_path = "${path.module}/python/run.zip"
}

# Lambda function
resource "aws_lambda_function" "terraform_lambda_function" {
  filename      = data.archive_file.zip_python_file.output_path
  function_name = "example_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "run.handler"
  code_sha256   = data.archive_file.zip_python_file.output_base64sha256

  runtime = "python3.12"
  depends_on = [ aws_iam_policy_attachment.attach_aws_iam_policy_role ]
}

output "terraform_aws_role_output" {
  value = aws_iam_role.lambda_role.name
}

output "terraform_aws_role_arn_output" {
  value = aws_iam_role.lambda_role.arn
}

output "terraform_logging_arn_output" {
  value = aws_iam_policy.policy.arn
}