# variable "project_id" {
#   description = "The GCP project ID"
# }

variable "ip_cidr_range" {
  default = "10.0.0.0/16"
}

variable "pods_cidr_range" {
  default = "10.1.0.0/16"
}

variable "services_cidr_range" {
  default = "10.2.0.0/16"
}

variable "ip_cidr_range2" {
  default = "10.3.0.0/16"
}

variable "pods_cidr_range2" {
  default = "10.4.0.0/16"
}

variable "services_cidr_range2" {
  default = "10.5.0.0/16"
}

variable "region" {
  default = "us-central1"
}
