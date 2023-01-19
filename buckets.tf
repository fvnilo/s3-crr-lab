locals {
  ca_central_bucket_name = "crr-ca-central-${random_string.random_suffix.result}"
  us_west_bucket_name    = "crr-us-west-${random_string.random_suffix.result}"
}

resource "aws_s3_bucket" "ca_central" {
  bucket = local.ca_central_bucket_name

  tags = {
    Name = local.ca_central_bucket_name
  }
}

resource "aws_s3_bucket_acl" "ca_central" {
  bucket = aws_s3_bucket.ca_central.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "ca_central" {
  bucket = aws_s3_bucket.ca_central.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "us_west" {
  provider = aws.uswest

  bucket = local.us_west_bucket_name

  tags = {
    Name = local.us_west_bucket_name
  }
}

resource "aws_s3_bucket_acl" "us_west" {
  provider = aws.uswest

  bucket = aws_s3_bucket.us_west.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "us_west" {
  provider = aws.uswest

  bucket = aws_s3_bucket.us_west.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "ca_central_to_us_west" {
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.ca_central]

  role   = aws_iam_role.ca_central_replication.arn
  bucket = aws_s3_bucket.ca_central.id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = aws_s3_bucket.us_west.arn
      storage_class = "STANDARD"
    }
  }
}

resource "aws_s3_bucket_replication_configuration" "us_west_to_ca_central" {
  provider = aws.uswest
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.us_west]

  role   = aws_iam_role.us_west_replication.arn
  bucket = aws_s3_bucket.us_west.id

  rule {
    id = "foobar"

    filter {
      prefix = "foo"
    }

    status = "Enabled"

    delete_marker_replication {
      status = "Enabled"
    }

    destination {
      bucket        = aws_s3_bucket.ca_central.arn
      storage_class = "STANDARD"
    }
  }
}
