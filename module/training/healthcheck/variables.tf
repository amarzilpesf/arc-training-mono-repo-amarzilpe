variable "project" {
  type        = string
  description = "The project name"
  default     = ""
}

variable "environment" {
  type        = string
  default     = "poc"
  description = "environment value, e.g 'prod', 'staging', 'dev', 'UAT'"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Name for the health check"
}

variable "domain_name" {
  type        = string
  description = "Domain name to be checked"
}

variable "resource_path" {
  type        = string
  description = "Path to the resource to be checked"
}

variable "type" {
  type        = string
  description = "Type of health check (e.g., HTTPS, HTTP, TCP)"
}

variable "measure_latency" {
  type        = bool
  description = "Whether to measure latency during the health check"
}

variable "failure_threshold" {
  type        = number
  description = "Number of consecutive health check failures to trigger an alarm"
}

variable "request_interval" {
  type        = number
  description = "Interval (in seconds) between health checks"
}

variable "alarm_prefix" {
  type        = string
  description = "Prefix for the alarm name"
}

variable "search_string" {
  type        = string
  description = "String to search for in the response"
}

variable "alarm_endpoint" {
  type        = string
  description = "Endpoint to send alarm notifications"
}
