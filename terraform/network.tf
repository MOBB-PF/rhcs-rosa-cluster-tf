module "vpc" {
  source               = "./modules/terraform-aws-modules"
  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = [var.azs]
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = var.tags
}