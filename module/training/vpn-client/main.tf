################################################################################
## defaults
################################################################################
terraform {
  required_version = ">= 1.3, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
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
  project     = var.project_name

  extra_tags = {
    Example  = "True"
    RepoPath = "github.com/sourcefuse/terraform-aws-refarch-vpn"
  }
}

################################################################################
## lookups
################################################################################
data "aws_vpc" "vpc" {
  filter {
    name = "tag:Name"
    values = [
      "${var.namespace}-${var.environment}-vpc"
    ]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name = "tag:Name"
    values = length(var.private_subnet_names_override) > 0 ? var.private_subnet_names_override : [
      "${var.namespace}-${var.environment}-vpc-vyshnavi-private-1",
      "${var.namespace}-${var.environment}-vpc-vyshnavi-private-2"
    ]
  }
}


################################################################################
## certs
################################################################################
module "self_signed_cert_ca" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-self-signed-cert.git?ref=1.3.0"

  attributes = ["self", "signed", "cert", "ca"]

  enabled = true

  namespace = var.namespace
  stage     = var.environment
  name      = "demo"

  secret_path_format = var.secret_path_format

  subject = {
    common_name  = "${var.namespace}-${var.environment}"
    organization = var.namespace
  }

  basic_constraints = {
    ca = true
  }

  allowed_uses = [
    "crl_signing",
    "cert_signing",
  ]

  certificate_backends = ["SSM"]
}

data "aws_ssm_parameter" "ca_key" {
  name = module.self_signed_cert_ca.certificate_key_path

  depends_on = [
    module.self_signed_cert_ca
  ]
}

module "self_signed_cert_root" {
  source = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-self-signed-cert.git?ref=1.3.0"

  enabled = true

  attributes = ["self", "signed", "cert", "root"]

  namespace = var.namespace
  stage     = var.environment
  name      = "demo"

  secret_path_format = var.secret_path_format

  subject = {
    common_name  = "${var.namespace}-${var.environment}.arc-vpn-example.client"
    organization = var.namespace
  }

  basic_constraints = {
    ca = false
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]

  certificate_backends = ["ACM", "SSM"]

  use_locally_signed = true

  certificate_chain = {
    cert_pem        = module.self_signed_cert_ca.certificate_pem,
    private_key_pem = join("", data.aws_ssm_parameter.ca_key[*].value)
  }
}


################################################################################
## vpn
################################################################################
module "vpn" {
  source  = "sourcefuse/arc-vpn/aws"
  version = "1.0.0" # pin the correct version

  vpc_id = data.aws_vpc.vpc.id

  authentication_options_type                       = "certificate-authentication"
  authentication_options_root_certificate_chain_arn = module.self_signed_cert_root.certificate_arn

  ## access
  client_vpn_authorize_all_groups = true
  client_vpn_subnet_ids           = data.aws_subnets.private.ids
  client_vpn_target_network_cidr  = data.aws_vpc.vpc.cidr_block

  ## self signed certificate
  create_self_signed_server_cert             = true
  self_signed_server_cert_server_common_name = "${var.namespace}-${var.environment}.arc-vpn-example.client"
  self_signed_server_cert_organization_name  = var.namespace
  self_signed_server_cert_ca_pem             = module.self_signed_cert_ca.certificate_pem
  self_signed_server_cert_private_ca_key_pem = join("", data.aws_ssm_parameter.ca_key[*].value)

  ## client vpn
  client_cidr             = cidrsubnet(data.aws_vpc.vpc.cidr_block, 6, 1)
  client_vpn_name         = "${var.namespace}-${var.environment}-client-vpn-example"
  client_vpn_gateway_name = "${var.namespace}-${var.environment}-vpn-gateway-example"

  tags = module.tags.tags
}
