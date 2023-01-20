resource "aws_iam_role" "source_replication" {
  name = "s3-replication-${var.source_bucket}"

  assume_role_policy = file("${path.module}/policies/replication_role.json")
}

resource "aws_iam_policy" "source_replication" {
  name = "s3-replication-${var.source_bucket}"

  policy = templatefile("${path.module}/policies/replication_policy.tftpl", { 
    source_bucket_arn = local.source_bucket_arn
    destination_bucket_arn = local.replicate_bucket_arn
  })
}

resource "aws_iam_role_policy_attachment" "source_replication" {
  role       = aws_iam_role.source_replication.name
  policy_arn = aws_iam_policy.source_replication.arn
}

resource "aws_iam_role" "replicate_replication" {
  count = var.bidirectional ? 1 : 0
  
  name = "s3-replication-${var.replicate_bucket}"

  assume_role_policy = file("${path.module}/policies/replication_role.json")
}

resource "aws_iam_policy" "replicate_replication" {
  count = var.bidirectional ? 1 : 0

  name = "s3-replication-${var.replicate_bucket}"

  policy = templatefile("${path.module}/policies/replication_policy.tftpl", { 
    source_bucket_arn = local.replicate_bucket_arn
    destination_bucket_arn = local.source_bucket_arn
  })
}

resource "aws_iam_role_policy_attachment" "replicate_replication" {
  count = var.bidirectional ? 1 : 0

  role       = aws_iam_role.replicate_replication[0].name
  policy_arn = aws_iam_policy.replicate_replication[0].arn
}