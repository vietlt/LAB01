terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "lab01-bucket"
    key    = "terraform.tfstate"
    region = "ap-southeast-1"
  }
}

// Define the region to create resources
provider "aws" {
  region = var.aws_region
}
