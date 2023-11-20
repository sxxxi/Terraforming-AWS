terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.27"
    }
  }
  required_version = ">= 0.14.6"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_iam_role" "l3_iam_role" {
  name = local.iam_role
}

data "aws_iam_instance_profile" "l3_iam_profile" {
  name = local.iam_instance_profile
}

module "l3_vpc" {
  source              = "./modules/vpc"
  vpc_cidr            = local.vpc_cidr_block
  public_cidr_blocks  = local.public_subnet_cidr_blocks
  private_cidr_blocks = local.private_subnet_cidr_blocks
  default_tags        = local.default_tags
  tags = {
    Name = "Lab3 VPC"
  }
}

# Cats ECR
module "cats_repo" {
  source    = "./modules/ecr"
  repo_name = local.cats_repo_name
}

# Dogs ECR
module "dogs_repo" {
  source    = "./modules/ecr"
  repo_name = local.dogs_repo_name
}


# Security group allowing SSH traffic
module "l3_bastion_sg_ssh" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "allow-ssh"
  vpc_id = module.l3_vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow SSH traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

# Security group allowing HTTP traffic in
module "l3_bastion_sg_http" {
  source = "terraform-aws-modules/security-group/aws"
  name   = "allow-http"
  vpc_id = module.l3_vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Allow HTTP traffic"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 0
      to_port     = 8080
      protocol    = "tcp"
      description = "Allow HTTP traffic"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 0
      to_port     = 8081
      protocol    = "tcp"
      description = "Allow HTTP traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_rules = ["all-all"]
}

module "l3_bastion_instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  ami                         = "ami-0230bd60aa48260c6"
  instance_type               = "t2.micro"
  name                        = "L3 Bastion"
  key_name                    = "vockey"
  vpc_security_group_ids      = [
    module.l3_bastion_sg_ssh.security_group_id,
    module.l3_bastion_sg_http.security_group_id
  ]
  associate_public_ip_address = true
  subnet_id                   = module.l3_vpc.public_subnets[0].id
  iam_instance_profile        = data.aws_iam_instance_profile.l3_iam_profile.name
  monitoring                  = true
}