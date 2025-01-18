resource "google_container_cluster" "kodiak_cluster" {
  name               = "kodiak-cluster"
#   location           = var.region
  initial_node_count = 1

  network    = var.network1
  subnetwork = var.network2

  datapath_provider = "ADVANCED_DATAPATH" # Enables Dataplane V2

  node_config {
    machine_type = "e2-medium"

    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]
  }

  ip_allocation_policy {
    # use_ip_aliases = true
  }

  enable_autopilot = false

#   node_locations = [var.region]
}

data "google_client_config" "default" {}

resource "null_resource" "install_stuff" {
  depends_on = [google_container_cluster.kodiak_cluster]

  provisioner "local-exec" {
    command = <<EOT
    # Fetch the credentials for the GKE cluster
    gcloud container clusters get-credentials kodiak-cluster --region us-central1-c

    # Install ArgoCD using Helm
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    helm install argocd argo/argo-cd --namespace argocd \
    --set server.service.type=LoadBalancer

    # Install Kyverno using Helm
    helm repo add kyverno https://kyverno.github.io/kyverno
    helm repo update
    helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace
    EOT
  }
}