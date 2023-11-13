provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "databases" {
  metadata {
    name = var.namespace_db
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

  ## Exemplo de criação de usuários ao subir o banco pela primeira vez e tabela de exemplo
  data = {
    "init.sql" = <<-EOT
      CREATE USER joao WITH PASSWORD 'password1';
      GRANT ALL PRIVILEGES ON DATABASE "db_wordpress" TO joao;
      CREATE USER beto WITH PASSWORD 'password2';
      GRANT ALL PRIVILEGES ON DATABASE "db_wordpress" TO beto;
      CREATE USER pedro WITH PASSWORD 'password3';
      GRANT ALL PRIVILEGES ON DATABASE "db_wordpress" TO pedro;
      CREATE TABLE load_data (id SERIAL PRIMARY KEY, nome VARCHAR(255) NOT NULL);
    EOT
  }
}

resource "kubernetes_secret" "postgres_password" {
  metadata {
    name      = "postgres-password"
    namespace = var.namespace_db
  }

  data = {
    "password" = "WFBUT1BvaW8wMCo5" #base64
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
            value = var.postgres_db_name
          }

          env {
            name  = "POSTGRES_USER"
            value = var.postgres_user
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_password.metadata[0].name
                key  = "password"
              }
            }
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
              cpu    = "128m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "256m"
              memory = "256Mi"
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
    namespace = var.namespace_db
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      protocol    = "TCP"
      port        = 5432
      target_port = 5432
      node_port   = 30432
    }

    type = "NodePort"
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
              cpu    = "128m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "256m"
              memory = "256Mi"
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

resource "kubernetes_service" "redis" {
  metadata {
    name      = "redis"
    namespace = kubernetes_namespace.databases.metadata[0].name
  }

  spec {
    selector = {
      app = "redis"
    }

    port {
      port        = 6379
      target_port = 6379
      node_port   = 30379
    }

    type = "NodePort"
  }
}

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

