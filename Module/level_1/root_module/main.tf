terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
    }
  }
  required_version = ">=1.15.4"
}

module "ec2module_1" {
  source = "../ec2_module_1"
  count = 3
}

module "ec2module_2" {
  source = "./ec2_module_2"
  count = 2
}

module "sgmodule" {
  source = "../../security_modules/sec_grp_module"
}