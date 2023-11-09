provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "kubernetes_namespace" "db_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "postgres" {
  name       = "my-postgres"
  chart      = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.namespace
  set {
    name  = "postgresPassword"
    value = "ModeloXPTO"
  }
}

resource "helm_release" "redis" {
  name       = "my-redis"
  chart      = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.namespace
  set {
    name  = "redisPassword"
    value = "XPTOioio"
  }
}
