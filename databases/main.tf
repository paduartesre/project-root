provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "databases" {
  metadata {
    name = "databases"
  }
}

resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "postgres-pvc"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

resource "kubernetes_config_map" "postgres_init_script" {
  metadata {
    name      = "postgres-init-script"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  data = {
    "init.sql" = <<-EOT
      CREATE USER joao WITH PASSWORD 'password1';
      GRANT ALL PRIVILEGES ON DATABASE "db_wordpress" TO joao;
      CREATE USER beto WITH PASSWORD 'password2';
      GRANT ALL PRIVILEGES ON DATABASE "db_wordpress" TO beto;
      CREATE USER pedro WITH PASSWORD 'password3';
      GRANT ALL PRIVILEGES ON DATABASE "db_wordpress" TO pedro;      
    EOT
  }
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:alpine3.18"
          name  = "postgres"

          env {
            name  = "POSTGRES_DB"
            value = "db_wordpress"
          }

          env {
            name  = "POSTGRES_USER"
            value = "db_user"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "XPTOPoio00*9"
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgres-storage"
          }

          volume_mount {
            mount_path = "/docker-entrypoint-initdb.d"
            name       = "init-script"
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "1024Mi"
            }
          }
        }

        volume {
          name = "postgres-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }

        volume {
          name = "init-script"

          config_map {
            name = kubernetes_config_map.postgres_init_script.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres_service" {
  metadata {
    name      = "postgres-service"
    namespace = "databases"
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"
  }
}

# Redis Deployment
resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "redis"
      }
    }

    template {
      metadata {
        labels = {
          app = "redis"
        }
      }

      spec {
        container {
          image = "redis:alpine3.18"
          name  = "redis"

          volume_mount {
            mount_path = "/data"
            name       = "redis-storage"
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "512Mi"
            }
          }
        }

        volume {
          name = "redis-storage"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.redis_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

# Persistent Volume Claim para Redis
resource "kubernetes_persistent_volume_claim" "redis_pvc" {
  metadata {
    name      = "redis-pvc"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

