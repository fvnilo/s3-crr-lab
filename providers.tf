terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "rafanilo-tf-states"
    key     = "s3-crr.tfstate"
    region  = "ca-central-1"
    encrypt = true
  }
}

provider "aws" {
  region = "ca-central-1"
}

provider "aws" {
  alias  = "uswest"
  region = "us-west-2"
}
