provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_job" "load-data" {
  metadata {
    name = "python-data-loader"
  }

  spec {
    template {
      metadata {
        name = "python-data-loader"
      }

      spec {
        container {
          image = "python:3.8"
          name  = "python-data-loader"

          command = ["python", "../scripts/load_data.py"]

          volume_mount {
            name       = "script-volume"
            mount_path = "/scripts"
          }
        }

        volume {
          name = "script-volume"

          config_map {
            name = "../configmaps/configmap-load-data.yaml"
          }
        }

        restart_policy = "Never"
      }
    }

    backoff_limit = 3
  }
}
