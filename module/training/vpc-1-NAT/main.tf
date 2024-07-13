################################################################
## defaults
################################################################
terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awsutils = {
      source  = "cloudposse/awsutils"
      version = "~> 0.18"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "awsutils" {
  region = var.region
}

module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = "terraform-aws-ref-arch-network"

  extra_tags = {
    Example = "True"
  }
}

data "aws_nat_gateway" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-public-${var.region}b"]
  }
}

module "network" {
  source                      = "sourcefuse/arc-network/aws"
  version                     = "2.7.0"
  namespace                   = var.namespace
  environment                 = var.environment
  availability_zones          = var.availability_zones
  vpc_ipv4_primary_cidr_block = var.vpc_ipv4_primary_cidr_block
  client_vpn_enabled          = false

  ## custom subnets
  custom_subnets_enabled = true
  custom_private_subnets = [
    {
      name              = "${var.namespace}-${var.environment}-private-${var.region}a"
      availability_zone = "${var.region}a"
      cidr_block        = "10.0.0.0/26"
    },
    {
      name              = "${var.namespace}-${var.environment}-private-${var.region}b"
      availability_zone = "${var.region}b"
      cidr_block        = "10.0.0.64/26"
    }
  ]
  custom_public_subnets = [
    {
      name              = "${var.namespace}-${var.environment}-public-${var.region}a"
      availability_zone = "${var.region}a"
      cidr_block        = "10.0.0.128/26"
    },
    {
      name              = "${var.namespace}-${var.environment}-public-${var.region}b"
      availability_zone = "${var.region}b"
      cidr_block        = "10.0.0.192/26"
    }
  ]

  // If have disabled the default nat gateways for your custom subnetes
  // then you need to pass a nat gateway id for each private subnet that
  // you are creating. If custom_az_ngw_ids is left empty in this case
  // then no default route is created by the module.

  custom_nat_gateway_enabled = false
  custom_az_ngw_ids = {
    "us-west-2a" = data.aws_nat_gateway.public.id
    "us-west-2b" = data.aws_nat_gateway.public.id
  }

  client_vpn_authorization_rules = [
    {
      target_network_cidr  = var.vpc_ipv4_primary_cidr_block
      authorize_all_groups = true
      description          = "default authorization group to allow all authenticated clients to access the vpc"
    }
  ]

  gateway_endpoint_route_table_filter = ["*private*"]

  tags = module.tags.tags
}
