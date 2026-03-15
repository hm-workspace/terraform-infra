terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Partial backend config — supply bucket/key/region/dynamodb_table via
  # -backend-config flags in CI or run `terraform init -reconfigure` locally.
  backend "s3" {}
}
