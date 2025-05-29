variable "provider_region" {
  default     = "us-east-1"
  type        = string
  description = "Região que serão provisionados os recursos."
}

variable "ip_range_ssh" {
  default     = "0.0.0.0/0"
  type        = string
  description = "Range IP para acesso via SSH."
}