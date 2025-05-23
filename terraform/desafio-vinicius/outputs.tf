output "public_instance_ip" {
  description = "IP público da instância EC2"
  value       = module.instance_desafio.public_ip
}