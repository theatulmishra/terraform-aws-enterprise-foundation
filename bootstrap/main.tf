provider "aws" {
  region = var.aws_region
}

locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
      Project     = var.project_name
    }
  )
}

# Generate a random ID to ensure a globally unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 6
}

# KMS Key for encrypting Terraform state at rest in the S3 bucket
resource "aws_kms_key" "state" {
  description             = "KMS key used to encrypt the remote terraform state files"
  deletion_window_in_days = 30
  enable_key_rotation     = true

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-kms-state" })
}

resource "aws_kms_alias" "state" {
  name          = "alias/${var.project_name}-${var.environment}-state-key"
  target_key_id = aws_kms_key.state.key_id
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "state" {
  bucket        = "${var.project_name}-${var.environment}-state-${lower(random_id.bucket_suffix.hex)}"
  force_destroy = false

  lifecycle {
    prevent_destroy = true
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-state-bucket" })
}

# Enable Versioning so we can recover from accidental deletions or state corruption
resource "aws_s3_bucket_versioning" "state" {
  bucket = aws_s3_bucket.state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt S3 bucket contents using the KMS Customer Managed Key
resource "aws_s3_bucket_server_side_encryption_configuration" "state" {
  bucket = aws_s3_bucket.state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Explicitly Block Public Access to prevent data leaks
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "locks" {
  name         = "${var.project_name}-${var.environment}-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  point_in_time_recovery {
    enabled = true
  }

  tags = merge(local.common_tags, { Name = "${var.project_name}-${var.environment}-locks-table" })
}
