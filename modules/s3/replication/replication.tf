resource "aws_s3_bucket_replication_configuration" "source_to_replicate" {
  role   = aws_iam_role.source_replication.arn
  bucket = var.source_bucket

  rule {
    id = "source-to-replicate"

    status = "Enabled"

    destination {
      bucket        = local.replicate_bucket_arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "replicate_to_source" {
  count = var.bidirectional ? 1 : 0

  provider = aws.replicate

  role   = aws_iam_role.replicate_replication[0].arn
  bucket = var.replicate_bucket

  rule {
    id = "replicate-to-source"

    status = "Enabled"

    destination {
      bucket        = local.source_bucket_arn
      storage_class = "STANDARD"
    }
  }
}
