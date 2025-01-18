# variable "project_id" {
#   description = "The GCP project ID"
# }

variable "region" {
  description = "The region where resources will be created"
  default     = "us-central1"
}

variable "ip_cidr_range" {
  default = "172.16.1.0/24"
}
variable "ip_cidr_range2" {
  default = "172.16.2.0/24"
}