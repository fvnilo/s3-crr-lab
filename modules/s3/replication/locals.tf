locals {
  source_bucket_arn = "arn:aws:s3:::${var.source_bucket}"
  replicate_bucket_arn = "arn:aws:s3:::${var.replicate_bucket}"
}
