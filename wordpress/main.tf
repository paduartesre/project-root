provider "kubernetes" {
  config_path = "~/.kube/config"
  
}

resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          image = "wordpress:latest"
          name  = "wordpress"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = "postgres.databases:5432"
          }

          env {
            name  = "WORDPRESS_DB_USER"
            value = "db_user"
          }

          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = "XPTOPoio00*9"
          }

          env {
            name  = "WORDPRESS_DB_NAME"
            value = "db_wordpress"
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress" {
  metadata {
    name = "wordpress"
  }

  spec {
    selector = {
      app = "wordpress"
    }

    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_horizontal_pod_autoscaler" "wordpress" {
  metadata {
    name = "wordpress"
  }

  spec {
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = "wordpress"
    }

    min_replicas = 1
    max_replicas = 10

    target_cpu_utilization_percentage = 50
  }
}
