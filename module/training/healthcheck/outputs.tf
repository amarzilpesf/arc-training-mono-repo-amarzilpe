output "sns_arn" {
  value       = module.health_check.sns_arn
  description = "SNS ARN"
}

output "route53_health_check_arn" {
  value       = module.health_check.route53_health_check_arn
  description = "Route53 Health check ARN"
}

output "cloudwatch_alarm_arn" {
  value       = module.health_check.cloudwatch_alarm_arn
  description = "Cloudwatch Alarm ARN"
}
