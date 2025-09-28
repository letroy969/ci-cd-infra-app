variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Application name used for resource naming"
  type        = string
  default     = "ci-cd-app"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "desired_count" {
  description = "ECS desired count (use 0 for infra-only step)"
  type        = number
  default     = 1
}
