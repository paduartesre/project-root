provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "db_namespace" {
  metadata {
    name = var.namespace
  }
}

module "postgresql" {
  source  = "bitnami/postgresql/kubernetes"
  version = "1.0.0"

  namespace       = kubernetes_namespace.db_namespace.metadata[0].name
  database        = var.postgres_db_name
  username        = var.postgres_user
  password        = var.postgres_password
  volume_mounts   = [{
    mount_path = "/bitnami/postgresql",
    name       = "data",
  }]
  volume_claims   = [{
    access_modes = ["ReadWriteOnce"]
    resources = {
      requests = {
        storage = "8Gi"
      }
    }
  }]
}

module "redis" {
  source  = "bitnami/redis/kubernetes"
  version = "1.0.0"

  namespace = kubernetes_namespace.db_namespace.metadata[0].name
  cluster_enabled = true
  password = var.redis_password
  master = {
    persistence = {
      enabled = true
      size = "8Gi"
    }
  }
}
