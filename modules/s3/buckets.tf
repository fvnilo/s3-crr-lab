locals {
  replicate_bucket_name = "${var.bucket_name}-replicate"
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "replicate" {
  count = var.enable_replication ? 1 : 0

  provider = aws.replicate

  bucket = local.replicate_bucket_name

  tags = {
    Name = local.replicate_bucket_name
  }
}

resource "aws_s3_bucket_acl" "replicate_acl" {
  count = var.enable_replication ? 1 : 0

  provider = aws.replicate

  bucket = aws_s3_bucket.replicate[0].id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "replicate_versioning" {
  count = var.enable_replication ? 1 : 0

  provider = aws.replicate

  bucket = aws_s3_bucket.replicate[0].id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "source_to_replicate" {
  count = var.enable_replication ? 1 : 0

  # Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.versioning,
    aws_s3_bucket_versioning.replicate_versioning[0]
  ]

  role   = aws_iam_role.source_replication[0].arn
  bucket = aws_s3_bucket.bucket.id

  rule {
    id = "source-to-replicate"

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replicate[0].arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "replicate_to_source" {
  count = var.enable_replication && var.bidirectional_replication ? 1 : 0

  provider = aws.replicate

  # Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.versioning,
    aws_s3_bucket_versioning.replicate_versioning[0]
  ]

  role   = aws_iam_role.replicate_replication[0].arn
  bucket = aws_s3_bucket.replicate[0].id

  rule {
    id = "replicate-to-source"

    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.bucket.arn
      storage_class = "STANDARD"
    }
  }
}
