terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.60.0"
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "foundation" {
  source = "../../"

  environment        = var.environment
  project_name       = var.project_name
  vpc_cidr           = "10.1.0.0/16"
  public_subnets     = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets    = ["10.1.10.0/24", "10.1.20.0/24"]
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  instance_type      = "t3.micro"
  min_size           = 1
  max_size           = 2

  tags = {
    Owner = "DevOps"
  }
}
