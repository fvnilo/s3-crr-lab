resource "aws_iam_role" "ca_central_replication" {
  name = "iam-role-ca-central-replication-${random_string.random_suffix.result}"

  assume_role_policy = file("${path.module}/policies/replication_role.json")
}

resource "aws_iam_policy" "ca_central_replication" {
  name = "iam-role-policy-ca-central-replication-${random_string.random_suffix.result}"

  policy = templatefile("${path.module}/policies/replication_policy.tftpl", { 
    source_bucket_arn = aws_s3_bucket.ca_central.arn,
    destination_bucket_arn = aws_s3_bucket.us_west.arn
  })
}

resource "aws_iam_role_policy_attachment" "ca_central_replication" {
  role       = aws_iam_role.ca_central_replication.name
  policy_arn = aws_iam_policy.ca_central_replication.arn
}

resource "aws_iam_role" "us_west_replication" {
  name = "iam-role-us-west-replication-${random_string.random_suffix.result}"

  assume_role_policy = file("${path.module}/policies/replication_role.json")
}

resource "aws_iam_policy" "us_west_replication" {
  name = "iam-role-policy-us-west-replication-${random_string.random_suffix.result}"

  policy = templatefile("${path.module}/policies/replication_policy.tftpl", { 
    source_bucket_arn = aws_s3_bucket.us_west.arn,
    destination_bucket_arn = aws_s3_bucket.ca_central.arn
  })
}

resource "aws_iam_role_policy_attachment" "us_west_replication" {
  role       = aws_iam_role.us_west_replication.name
  policy_arn = aws_iam_policy.us_west_replication.arn
}