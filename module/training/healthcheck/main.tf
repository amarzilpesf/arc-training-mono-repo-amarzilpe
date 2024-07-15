################################################################################
## defaults
################################################################################
terraform {
  required_version = "~> 1.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  #   backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.project


  extra_tags = {
    Repo         = "terraform-aws-refarch-healthcheck"
    MonoRepo     = "True"
    MonoRepoPath = "terraform/healthcheck"
  }
}

module "health_check" {
  source            = "sourcefuse/arc-healthcheck/aws"
  version           = "0.0.8"
  name              = var.name
  domain_name       = var.domain_name
  resource_path     = var.resource_path
  type              = var.type
  measure_latency   = var.measure_latency
  alarm_prefix      = var.alarm_prefix
  failure_threshold = var.failure_threshold
  request_interval  = var.request_interval
  search_string     = var.search_string
  alarm_endpoint    = var.alarm_endpoint

  tags = module.tags.tags

}
