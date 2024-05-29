output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.pub_subnet_id
}

output "private_subnet_id" {
  value = module.vpc.pvt_subnet_id
}

output "nat_gateway_id" {
  value = module.vpc.nat_gateway_id
}

output "instance_public_ip" {
  description = "Get instance Public Ip's"
  value       = module.ec2.instance_public_ip
}

output "instance_ids" {
  description = "Get EC2 instance ids"
  value       = module.ec2.instance_id
}

# output "rds_endpoint" {
#   value = module.rds.rds_endpoint
# }
