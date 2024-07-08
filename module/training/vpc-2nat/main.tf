################################################################
## defaults
################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      version = "~> 4.0"
      source  = "hashicorp/aws"
    }

    awsutils = {
      source  = "cloudposse/awsutils"
      version = "~> 0.15"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "awsutils" {
  region = var.region
}

module "terraform-aws-arc-tags" {
  source      = "sourcefuse/arc-tags/aws"
  version     = "1.2.5"
  environment = var.environment
  project     = var.project_name

  extra_tags = {
    MonoRepo     = "True"
    MonoRepoPath = "terraform/network"
  }
}

################################################################
## network
################################################################
module "network" {
  source  = "sourcefuse/arc-network/aws"
  version = "2.6.3"

  namespace          = var.namespace
  availability_zones = var.availability_zones
  environment        = var.environment

  vpc_ipv4_primary_cidr_block    = var.vpc_cidr_block
  vpc_endpoints_enabled          = false
  vpn_gateway_enabled            = false
  direct_connect_enabled         = false
  interface_vpc_endpoints        = {}
  gateway_vpc_endpoints          = {}
  client_vpn_authorization_rules = []

  tags = module.terraform-aws-arc-tags.tags
}

# module "network" {
#   source                      = "sourcefuse/arc-network/aws"
#   version                     = "2.7.0"
#   namespace                   = var.namespace
#   environment                 = var.environment
#   availability_zones          = var.availability_zones
#   vpc_ipv4_primary_cidr_block = var.vpc_ipv4_primary_cidr_block
#   client_vpn_enabled          = false
#   tags                        = module.terraform-aws-arc-tags.tags
#   client_vpn_authorization_rules = [
#     {
#       target_network_cidr  = var.vpc_ipv4_primary_cidr_block
#       authorize_all_groups = true
#       description          = "default authorization group to allow all authenticated clients to access the vpc"
#     }
#   ]

#   vpc_endpoint_config = {
#     s3         = true
#     kms        = false
#     cloudwatch = false
#     elb        = false
#     dynamodb   = true
#     ec2        = false
#     sns        = true
#     sqs        = true
#     ecs        = true
#     rds        = true
#   }
#   gateway_endpoint_route_table_filter = ["*private*"]
# }
