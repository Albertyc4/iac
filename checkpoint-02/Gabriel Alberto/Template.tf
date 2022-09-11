# PROVIDER
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# REGION
provider "aws" {
    region = "us-east-1"
    shared_credentials_file = ".aws/credentials"
}

# BUCKET S3
resource "aws_s3_bucket" "s3-alberty" {
  bucket = "s3-alberty"
}

# STATIC SITE
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.alberty.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# ACL S3
resource "aws_s3_bucket_acl" "aclsalb" {
  bucket = aws_s3_bucket.alberty.id

  acl = "public-read"
}

#S3 UPLOAD OBJECT
resource "aws_s3_bucket_object" "error" {
  key = "error.html"
  bucket = aws_s3_bucket.alberty.id
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "index" {
  key = "index.html"
  bucket = aws_s3_bucket.alberty.id
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

# POLICY S3
resource "aws_s3_bucket_policy" "policy-alb" {
  bucket = aws_s3_bucket.alberty.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect     = "Allow",
        Principal  = "*",
        Action    = "s3:GetObject",
        Resource = "arn:aws:s3:::s3-95128/*",
      }
    ]
	})
}

# VERSIONING S3 BUCKET
resource "aws_s3_bucket_versioning" "version" {
  bucket = aws_s3_bucket.alberty.id
  versioning_configuration {
    status = "Enabled"
  }
}
