terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.4.0"
}


// I am experimenting this 
# provider "google" {
#   project = "kodiak-448212"
#   zone    = "us-central1-c"
#   # Use your service account impersonation
#   impersonate_service_account = "kodiac-svc-acc@kodiak-448212.iam.gserviceaccount.com"
#   # Using workload identity provider via external OIDC token
#   access_token = var.access_token
# }

provider "google" {
  project = "kodiak-448212"
  region  = "us-central1"
  zone    = "us-central1-c"
  
}