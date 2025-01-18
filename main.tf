module "vpc" {
  source = "./modules/vpc"
}

module "gke" {
  source = "./modules/gke"
  network1 = module.vpc.vpc_network_name
  network2 = module.vpc.subnet2_name
}