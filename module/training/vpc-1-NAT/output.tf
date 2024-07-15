output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "NAT_id" {
  value = data.aws_nat_gateway.public.id
}
