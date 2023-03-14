locals {
  bucket_name = "crr-lab-${random_string.random_suffix.result}"
}

module "s3" {
    source = "./modules/s3"

    providers = {
      aws.replicate = aws.uswest2
    }

    bucket_name = local.bucket_name

    enable_replication = true
    bidirectional_replication = true
}
