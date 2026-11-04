terraform {
  required_version = ">= 1.5.0"   # Requires Terraform version 1.5 or newer

  required_providers {
    aws = {
      source  = "hashicorp/aws"   # Official AWS plugin from Terraform Registry
      version = "~> 5.0"          # Allows 5.x versions, but avoids breaking 6.0
    }
  }
}

provider "aws" {
  region = var.aws_region         # Tells AWS which data center to use (Sydney)
}
