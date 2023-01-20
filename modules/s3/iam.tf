resource "aws_iam_role" "source_replication" {
  count = var.enable_replication ? 1 : 0

  name = "s3-replication-${var.bucket_name}"

  assume_role_policy = file("${path.module}/policies/replication_role.json")
}

resource "aws_iam_policy" "source_replication" {
  count = var.enable_replication ? 1 : 0

  name = "s3-replication-${var.bucket_name}"

  policy = templatefile("${path.module}/policies/replication_policy.tftpl", { 
    source_bucket_arn = aws_s3_bucket.bucket.arn,
    destination_bucket_arn = aws_s3_bucket.replicate[0].arn
  })
}

resource "aws_iam_role_policy_attachment" "source_replication" {
  count = var.enable_replication ? 1 : 0

  role       = aws_iam_role.source_replication[0].name
  policy_arn = aws_iam_policy.source_replication[0].arn
}

resource "aws_iam_role" "replicate_replication" {
  count = var.enable_replication && var.bidirectional_replication ? 1 : 0
  
  name = "s3-replication-${local.replicate_bucket_name}"

  assume_role_policy = file("${path.module}/policies/replication_role.json")
}

resource "aws_iam_policy" "replicate_replication" {
  count = var.enable_replication && var.bidirectional_replication ? 1 : 0

  name = "s3-replication-${local.replicate_bucket_name}"

  policy = templatefile("${path.module}/policies/replication_policy.tftpl", { 
    source_bucket_arn = aws_s3_bucket.replicate[0].arn,
    destination_bucket_arn = aws_s3_bucket.bucket.arn
  })
}

resource "aws_iam_role_policy_attachment" "replicate_replication" {
  count = var.enable_replication && var.bidirectional_replication ? 1 : 0

  role       = aws_iam_role.replicate_replication[0].name
  policy_arn = aws_iam_policy.replicate_replication[0].arn
}