variable "region" {
  description = "AWS Region to deploy to."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "test"
}

variable "project_name" {
  description = "Project name."
  type        = string
  default     = "foundation-demo"
}
