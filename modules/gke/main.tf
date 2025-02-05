resource "google_container_cluster" "kodiak_cluster" {
  name               = "kodiak-cluster"
  location           = var.region
  initial_node_count = 4

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
    gcloud config set project kodiak-448212
    gcloud container clusters get-credentials kodiak-cluster --region us-central1-c

    # Install ArgoCD using Helm
    kubectl create ns argocd
    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    helm install argocd argo/argo-cd \
        --namespace argocd --create-namespace \
        --version 7.8.0 \
        --set server.service.type=LoadBalancer \
        --set controller.image.tag=v2.14.0

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

    # Install Grafana using Helm
    kubectl create ns grafana
    helm repo add grafana https://grafana.github.io/helm-charts
    helm repo update
    helm install grafana grafana/grafana --namespace grafana \
    --set service.type=LoadBalancer

    # Install NGINX Ingress Controller using Helm
    kubectl create ns ingress-nginx
    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
    helm install nginx-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace \
        --set controller.service.type=LoadBalancer

    # create a datadog secret (I did this outside since I dont want to expose my datadog api or hide the variables.tf) //<YOUR_DATADOG_API_KEY>
    kubectl create secret generic datadog-secret --namespace datadog --create-namespace \
         --from-literal api-key=<YOUR_DATADOG_API_KEY>               


    # Install Datadog Agent using Helm
    kubectl create ns datadog
    helm repo add datadog https://helm.datadoghq.com
    helm repo update
    helm install datadog-operator datadog/datadog-operator --namespace datadog --create-namespace 

      //Dont use instead it will be applied on the gitops side
        # --set datadog.apiKeyExistingSecret=datadog-secret \
        # --set datadog.logs.enabled=true \
        # --set datadog.service.type=LoadBalancer
        # --set datadog.logs.containerCollectAll=true \
        # --set datadog.logs.containerRuntime="docker" \
        # --set datadog.apm.enabled=true \
        # --set datadog.apm.portEnabled=true \
        # --set datadog.kubeStateMetricsCore.enabled=true \
        # --set datadog.clusterName=kodiak-cluster


    echo "Prometheus, Grafana, NGINX Ingress Controller, and Datadog installed. Access services using their LoadBalancer IPs."
    EOT
  }
}
