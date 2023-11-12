variable "postgres_db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "db_wordpress"
}

variable "postgres_user" {
  description = "The PostgreSQL user"
  type        = string
  default     = "db_user"
}

variable "namespace_db" {
  description = "Kubernetes namespace"
  type        = string
  default     = "databases"
}
