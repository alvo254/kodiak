variable "network_id" {
  type = string
}

variable "subnetwork_name" {
  type = string
}
variable "region" {
  default = "us-central1-c"
}
variable "pods_range_name" {
  type = string
}

variable "services_range_name" {
  type = string
}
