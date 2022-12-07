terraform {
  backend s3 {} # Should be manually created before running this code
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.38.0"
    }
  }
}

locals {
  tags = {
    Terraform = "true"
    Stack     = var.stack_name
    Region    = var.aws_region

  }
}

module "vpc" {
  source                      = "./modules/vpc"
  vpc_cidr                    = var.vpc_cidr
  vpc_subnet_newbits          = var.vpc_subnet_newbits
  vpc_subnet_count            = var.vpc_subnet_count
  region                      = var.aws_region
  tags                        = local.tags
}

# For practice, nothing to do with this infrastructure.
module "s3" {
  source                      = "./modules/s3"
  tags                        = local.tags
}

module "iam" {
  source                      = "./modules/iam"
  tags                        = local.tags
}

# For practice, nothing to do with this infrastructure.
module "route53" {
  source                      = "./modules/route53"
  zone_id                     = var.zone_id
  tags                        = local.tags
}

# For practice, nothing to do with this infrastructure.
module "sm" {
  source                      = "./modules/sm"
  tags                        = local.tags
}

module "lb" {
  source                      = "./modules/lb"
  vpc_id                      = module.vpc.vpc_id
  subnet_ids                  = module.vpc.subnet_ids
  sg_id                       = module.vpc.sg_id
  bucket_log                  = module.s3.bucket_log
  ec2_instance_count          = var.ec2_instance_count
  instance_ids                = module.ec2.instance_ids
  zone_id                     = var.zone_id
  subdomain                   = var.subdomain
  tags                        = local.tags
  depends_on                  = [module.vpc]
}

module "ec2" {
  source                      = "./modules/ec2_instance"
  subnet_id                   = module.vpc.subnet_ids[1]
  sg_id                       = module.vpc.sg_id
  ec2_instance_count          = var.ec2_instance_count
  ec2_profile                 = module.iam.ec2_profile_name
  instance_type               = var.ec2_instance_type
  ami                         = var.ec2_ami
  disk_size                   = 20
  disk_type                   = "gp2"
  nginx_shell_path            = var.nginx_shell_path
  region                      = var.aws_region
  tags                        = local.tags
  depends_on                  = [module.vpc]
}

module "rds" {
  source                      = "./modules/rds"
  tags                        = local.tags
  subnet_ids                  = module.vpc.subnet_ids
  sg_id                       = module.vpc.sg_id
  depends_on                  = [module.vpc]
}