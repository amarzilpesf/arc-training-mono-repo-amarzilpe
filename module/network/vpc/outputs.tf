output "vpc_id" {
  value       = aws_vpc.main.id
  description = "VPC id"
}

# output "public_subnet_id_01" {
#   value = aws_subnet.public_subnet[0].id
# }

output "pub_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "pvt_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}