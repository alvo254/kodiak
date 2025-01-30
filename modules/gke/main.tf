resource "google_container_cluster" "kodiak_cluster" {
  name               = "kodiak-cluster"
  location           = var.region
  initial_node_count = 2

  //Not working as expected
  datapath_provider = "ADVANCED_DATAPATH" # Enables Dataplane V2 cilium stuff :)

  network    = var.network_id
  subnetwork = var.subnetwork_name

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

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
}



data "google_client_config" "default" {}

resource "null_resource" "install_stuff" {
  depends_on = [google_container_cluster.kodiak_cluster]

  provisioner "local-exec" {
    command = <<EOT
    # Fetch the credentials for the GKE cluster
    # gcloud components install gke-gcloud-auth-plugin  //install this on your computer using curl or something
    gcloud config set project kodiak-448212
    gcloud container clusters get-credentials kodiak-cluster --region us-central1-c

    # Install ArgoCD using Helm
    kubectl create ns argocd
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    helm install argocd argo/argo-cd --namespace argocd \
    --set server.service.type=LoadBalancer 

    # Install Kyverno using Helm
    helm repo add kyverno https://kyverno.github.io/kyverno
    helm repo update
    helm install kyverno kyverno/kyverno --namespace kyverno --create-namespace

    # Install Prometheus using Helm
    kubectl create ns monitoring
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring \
      --set prometheus.service.type=LoadBalancer \
      --set prometheus.prometheusSpec.service.type=LoadBalancer
    
    //Dont uncomment still investigating use advance_datapath
    # Cilium install 
    # helm install cilium cilium/cilium --namespace kube-system \
    #     --set hubble.enabled=true \
    #     --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,http}" \
    #     --set hubble.relay.enabled=true \
    #     --set hubble.ui.enabled=true \
    #     --set hubble.peer.target="hubble-peer.kube-system.svc.cluster.local:4244" \
    #     --set tetragon.export.pprof.enabled=true \
    #     --set tetragon.export.hubble.enabled=true \
    #     --set tetragon.resources.requests.cpu=100m \
    #     --set tetragon.resources.requests.memory=100Mi \
    #     --set tetragon.resources.limits.cpu=500m \
    #     --set tetragon.resources.limits.memory=500Mi \

    # Install Grafana using Helm
    kubectl create ns grafana
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm install grafana grafana/grafana --namespace grafana \
    --set service.type=LoadBalancer

    echo "Prometheus and Grafana installed. Access Grafana using the LoadBalancer IP and default admin credentials (admin/prometheus)."
  
    EOT
  }
}