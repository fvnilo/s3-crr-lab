output "bucket_id" {
  description = "The id of the created bucket."
  value = aws_s3_bucket.bucket.id
}

output "bucket_arn" {
  description = "The arn of the created bucket."
  value = aws_s3_bucket.bucket.arn
}