module "core" {
  source = "../../module"

  aws_region       = var.aws_region
  vpc_cidr         = var.vpc_cidr
  azs              = var.azs
  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  intra_subnets    = var.intra_subnets
  cluster_name     = var.cluster_name
  instance_type    = var.instance_type
  tags             = var.tags
}