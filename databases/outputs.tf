output "postgresql_external_ip" {
  value = module.postgresql.external_ip
}

output "redis_external_ip" {
  value = module.redis.master_service[0].load_balancer[0].ingress[0].ip
}
