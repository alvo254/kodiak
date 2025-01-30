resource "google_compute_network" "vpc_network" {
  name = "kodiak"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = var.subnet1_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id

  secondary_ip_range {
    range_name    = "pods-range"
    ip_cidr_range = var.pods_cidr_range
  }
  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.services_cidr_range
  }
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = var.subnet2_cidr_range
  region        = var.region
  network       = google_compute_network.vpc_network.id

  secondary_ip_range {
    range_name    = "pods-range2"
    ip_cidr_range = var.pods_cidr_range2
  }
  secondary_ip_range {
    range_name    = "services-range2"
    ip_cidr_range = var.services_cidr_range2
  }
}
