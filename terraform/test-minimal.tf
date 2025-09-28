# Minimal Terraform test configuration
# This creates a simple random ID to test if Terraform is working

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.9.0"
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "test-app"
}

variable "desired_count" {
  description = "Desired count"
  type        = number
  default     = 0
}

# Simple test resource - just a random ID
resource "random_id" "test" {
  byte_length = 8
}

output "test_id" {
  value = random_id.test.hex
}
