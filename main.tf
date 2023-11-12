
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Load Data - Configmap para realizar carga de dados
resource "kubernetes_manifest" "configmap_loaddata" {
  manifest = yamldecode(file("${path.module}/configmaps/configmap-load-data.yaml"))
}
