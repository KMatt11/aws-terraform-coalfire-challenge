# root main.tf

# networking module
module "networking" {
  source             = "./modules/networking"
  vpc_cidr           = var.vpc_cidr
  public_cidrs       = var.public_cidrs
  private_cidrs      = var.private_cidrs
  availability_zones = var.availability_zones
  access_ip          = var.access_ip
  project_name       = var.project_name
}

# s3 module
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
  environment  = var.environment
  tags         = var.tags
}

# load balancing module
module "loadbalancing" {
  source         = "./modules/loadbalancing"
  public_sg      = module.networking.public_security_group_id
  public_subnets = module.networking.public_subnet_ids
  vpc_id         = module.networking.vpc_id
  tags           = var.tags
}

# compute module
module "compute" {
  source                = "./modules/compute"
  private_sg            = module.networking.private_security_group_id
  private_subnets       = module.networking.private_subnet_ids
  key_name              = var.key_name
  lb_target_group_arn   = module.loadbalancing.target_group_arn
  private_instance_type = var.private_instance_type
  images_bucket_arn     = module.s3.bucket_arn
  project_name          = var.project_name
  tags                  = var.tags
}
