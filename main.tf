module "vpc" {
  source = "./modules/vpc"
}

module "gke" {
  source            = "./modules/gke"
  # region            = var.region
  network_id        = module.vpc.vpc_network_id
  subnetwork_name   = module.vpc.subnet1_name
  pods_range_name   = module.vpc.subnet1_pods_range_name
  services_range_name = module.vpc.subnet1_services_range_name
}
