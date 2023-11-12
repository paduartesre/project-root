provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_manifest" "wordpress_deployment" {
  manifest = yamldecode(file("${path.module}/k8s-config/wordpress-deployment.yaml"))
}

resource "kubernetes_manifest" "secrets" {
  manifest = yamldecode(file("${path.module}/k8s-config/secrets.yaml"))
}

resource "kubernetes_manifest" "autoscaling" {
  manifest = yamldecode(file("${path.module}/k8s-config/autoscaling.yaml"))
}

resource "kubernetes_manifest" "wordpress_service" {
  manifest = yamldecode(file("${path.module}/k8s-config/wordpress-service.yaml"))
}

resource "kubernetes_manifest" "wordpress_ingress" {
  manifest = yamldecode(file("${path.module}/k8s-config/wordpress-ingress.yaml"))
}

resource "kubernetes_manifest" "mysql_deployment" {
  manifest = yamldecode(file("${path.module}/k8s-config/mysql-deployment.yaml"))
}

resource "kubernetes_manifest" "mysql_service" {
  manifest = yamldecode(file("${path.module}/k8s-config/mysql-service.yaml"))
}
