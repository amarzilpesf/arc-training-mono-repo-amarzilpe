output "azs" {
  description = "Get the list of availability zones in a Region"
  value       = data.aws_availability_zones.azs.names
}

output "instance_public_ip" {
  description = "Get instance Public Ip's"
  value       = { for ipi, instance in aws_instance.web : ipi => instance.public_ip }
}

output "instance_ids" {
  description = "Get EC2 instance ids"
  value       = { for id, instance in aws_instance.web : id => instance.public_ip }
}
