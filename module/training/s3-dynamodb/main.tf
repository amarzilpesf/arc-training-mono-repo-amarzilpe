terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      version = "~> 3.0"
      source  = "hashicorp/aws"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "aws" {
  region = var.region
  alias  = "backend_state"
}

module "bootstrap" {
  source        = "sourcefuse/arc-bootstrap/aws"
  version       = "1.1.6"
  bucket_name   = var.bucket_name
  dynamodb_name = var.dynamodb_name
}
