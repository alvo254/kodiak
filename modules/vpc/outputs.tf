output "vpc_network_id" {
  description = "The ID of the VPC network."
  value       = google_compute_network.vpc_network.id
}

output "subnet1_name" {
  description = "The name of the first subnetwork."
  value       = google_compute_subnetwork.subnet1.name
}

output "subnet1_pods_range_name" {
  description = "The name of the Pods secondary range in subnet1."
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[0].range_name
}

output "subnet1_services_range_name" {
  description = "The name of the Services secondary range in subnet1."
  value       = google_compute_subnetwork.subnet1.secondary_ip_range[1].range_name
}

output "subnet2_name" {
  description = "The name of the second subnetwork."
  value       = google_compute_subnetwork.subnet2.name
}

output "subnet2_pods_range_name" {
  description = "The name of the Pods secondary range in subnet2."
  value       = google_compute_subnetwork.subnet2.secondary_ip_range[0].range_name
}

output "subnet2_services_range_name" {
  description = "The name of the Services secondary range in subnet2."
  value       = google_compute_subnetwork.subnet2.secondary_ip_range[1].range_name
}
