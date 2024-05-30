terraform {
  required_version = "~> 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }
}

provider "tls" {
  # Configuration options
}

# Configure the AWS Provider
provider "aws" {
  region  = "ap-south-1"
  profile = "arc-iac"
}
