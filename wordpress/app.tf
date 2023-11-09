resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 3
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

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "wordpress_service" {
  metadata {
    name = "wordpress-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "wordpress"
    }

    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

