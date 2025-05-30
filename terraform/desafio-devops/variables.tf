variable "provider_region" {
  type        = string
  description = "Região que serão provisionados os recursos."
}

variable "ip_range_ssh" {
  type        = string
  description = "Range IP para acesso via SSH."
}