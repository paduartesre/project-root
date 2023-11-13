## Este arquivo apenas poderá ser utilizado se a criação
## dos recursos forem via "resources" do terraform, 
## referenciando estas variáveis para obter alguns valores de configurações

variable "wordpress_version" {
  description = "A versão da imagem do WordPress a ser utilizada."
  type        = string
  default     = "latest"
}

variable "replica_count" {
  description = "Número de réplicas do pod do WordPress."
  type        = number
  default     = 3
}

variable "service_port" {
  description = "A porta em que o serviço do WordPress será exposto."
  type        = number
  default     = 80
}

variable "node_port" {
  description = "NodePort para expor o serviço (se necessário)."
  type        = number
  default     = 30080
}

variable "resource_limits" {
  description = "Limites de CPU e Memória para o WordPress."
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "500m"
    memory = "512Mi"
  }
}

variable "namespace_wp" {
  description = "Kubernetes namespace"
  type        = string
  default     = "wordpress"
}
