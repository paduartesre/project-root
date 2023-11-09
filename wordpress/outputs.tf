output "wordpress_external_ip" {
  value = kubernetes_service.wordpress_service.status[0].load_balancer[0].ingress[0].ip
}

output "wordpress_url" {
  value = "http://${kubernetes_service.wordpress_service.status[0].load_balancer[0].ingress[0].ip}"
}

output "wordpress_namespace" {
  value = kubernetes_service.wordpress_service.metadata[0].namespace
}

output "wordpress_service_details" {
  value = kubernetes_service.wordpress_service
}
