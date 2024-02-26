module "vpc" {
  source = "./modules/vpc"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
}

module "load_balancer" {
  source          = "./modules/loadbalancer"
  port            = module.security.port
  vpc_id          = module.vpc.vpc_id
  security_groups = module.security.sg_id
  subnets         = [for subnet in module.vpc.public_subents : subnet]
}

module "compute" {
  source                 = "./modules/compute"
  vpc_security_group_ids = module.security.sg_id
  user_data              = base64encode(templatefile("user_data.tftpl", { s3bucketname = module.s3.s3bucketname }))
  vpc_zone_identifier    = [for subnet in module.vpc.private_subents : subnet]
  target_group_arns      = module.load_balancer.target_group_arns
}
