output "db_admin_username" {
  description = "DB Admin username to the SQL Server"
  value       = var.db_admin_username
}

## aurora
output "aurora_endpoint" {
  value       = module.aurora.aurora_endpoint
  description = "The DNS address of the Aurora instance"
}

output "aurora_arn" {
  value       = module.aurora.aurora_arn
  description = "Amazon Resource Name (ARN) of cluster"
}
