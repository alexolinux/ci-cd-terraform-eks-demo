terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.43.0"
    }
  }

  backend "s3" {
    bucket = "ci-cd-terraform-eks-demo-2024"
    key    = "eks.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
