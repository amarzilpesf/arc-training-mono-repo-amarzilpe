output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id"
}

output "pub_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "pvt_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}

output "nat_gateway_id" {
  value = aws_eip.nat_gtw_eip.id
}
