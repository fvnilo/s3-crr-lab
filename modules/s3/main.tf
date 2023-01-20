locals {
  replicate_bucket_name = "${var.bucket_name}-replicate"
}

module "bucket" {
  source = "./bucket"

  bucket_name = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

module "replicate" {
  providers = {
    aws = aws.replicate
  }

  count  = var.enable_replication ? 1 : 0
  source = "./bucket"

  bucket_name = local.replicate_bucket_name

  tags = {
    Name = local.replicate_bucket_name
  }
}

module "replication" {
  depends_on = [
    module.bucket,
    module.replicate
  ]

  providers = {
    aws.replicate = aws.replicate
   }

  count = var.enable_replication ? 1 : 0

  source = "./replication"

  source_bucket    = module.bucket.bucket_id
  replicate_bucket = module.replicate[0].bucket_id
  bidirectional    = var.bidirectional_replication
}
