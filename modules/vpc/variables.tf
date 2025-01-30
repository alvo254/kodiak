# variable "project_id" {
#   description = "The GCP project ID"
# }
variable "ip_cidr_range" {
  description = "The CIDR range for the VPC network"
  default     = "172.16.0.0/16"
}

variable "subnet1_cidr_range" {
  description = "The CIDR range for Subnet 1"
  default     = "172.16.1.0/24"
}

variable "subnet2_cidr_range" {
  description = "The CIDR range for Subnet 2"
  default     = "172.16.2.0/24"
}

variable "pods_cidr_range" {
  description = "The CIDR range for Pod IPs in subnet1"
  default     = "10.0.0.0/14"
}

variable "services_cidr_range" {
  description = "The CIDR range for Service IPs in subnet1"
  default     = "10.4.0.0/19"
}

variable "pods_cidr_range2" {
  description = "The CIDR range for Pod IPs in subnet2"
  default     = "10.8.0.0/14"  
}

variable "services_cidr_range2" {
  description = "The CIDR range for Service IPs in subnet2"
  default     = "10.12.0.0/19" 
}

variable "region" {
  description = "The region where resources will be created"
  default     = "us-central1"
}
