resource "aws_s3_bucket" "bucket" {
  bucket              = "across-account-terraform-state-backend"
  object_lock_enabled = true
  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encrypt" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.bucket.id
  rule {
    id = "rule-versioning"
    noncurrent_version_expiration {
      noncurrent_days           = 90
      newer_noncurrent_versions = 30
    }
    status = "Enabled"
  }
}