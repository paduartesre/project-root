variable "postgres_db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "wordpress"
}

variable "postgres_user" {
  description = "The PostgreSQL user"
  type        = string
  default     = "wp_user"
}

variable "postgres_password" {
  description = "The password for the PostgreSQL user"
  type        = string
  default     = "wp_password"
}

variable "redis_password" {
  description = "The password for Redis"
  type        = string
  default     = "redis_password"
}

variable "namespace_db" {
  description = "Kubernetes namespace"
  type        = string
  default     = "databases"
}
