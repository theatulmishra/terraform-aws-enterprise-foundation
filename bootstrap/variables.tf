variable "aws_region" {
  description = "The AWS region to deploy the remote state infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "ent-foundation"
}

variable "environment" {
  description = "Environment identifier (e.g. bootstrap, dev, prod)."
  type        = string
  default     = "bootstrap"
}

variable "tags" {
  description = "Default tags to apply to all resources."
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "RemoteStateBackend"
  }
}
