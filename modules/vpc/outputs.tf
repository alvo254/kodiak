output "vpc_network_name" {
  value = google_compute_network.vpc_network.id
}

output "subnet1_name" {
  value = google_compute_subnetwork.subnet1.id
}

output "subnet2_name" {
  value = google_compute_subnetwork.subnet2.id
}
