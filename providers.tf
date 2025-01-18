terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.4.0"
}

provider "google" {
  project = "koidak"
  region  = "us-central1"
  zone    = "us-central1-c"
}