
resource "google_compute_network" "vpc_network" {
  name                    = "kodiak"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet1"
  ip_cidr_range = var.ip_cidr_range
#   region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet2"
  ip_cidr_range = var.ip_cidr_range2
  region        = var.region
  network       = google_compute_network.vpc_network.id
}



