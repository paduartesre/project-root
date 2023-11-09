provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "postgres" {
  name       = "my-postgres"
  chart      = "postgresql"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.namespace_db

  set {
    name  = "postgresPassword"
    value = "ModeloXPTO"
  }

  set {
    name  = "resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "500m"
  }
}

resource "helm_release" "redis" {
  name       = "my-redis"
  chart      = "redis"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.namespace_db

  set {
    name  = "redisPassword"
    value = "XPTOioio"
  }

  set {
    name  = "master.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "master.resources.requests.cpu"
    value = "200m"
  }

  set {
    name  = "master.resources.limits.memory"
    value = "512Mi"
  }

  set {
    name  = "master.resources.limits.cpu"
    value = "500m"
  }
}
