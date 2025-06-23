terraform {
  required_version = ">=1.9.3"
  required_providers {
    terraform = {
      source = "terraform.io/builtin/terraform"
    }
    stackit = {
      source  = "stackitcloud/stackit"
      version = "0.51.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.97.0"
    }
  }
}

module "objectstorage-bucket" {
  source = "../../../../managed-service-catalog/terraform/modules/objectstorage-bucket"

  project_id             = "38867e9e-b5d4-4a85-97a8-0a944ab75b19" # stackit project id
  credentials_group_name = "cg-controlplane-work-prod"            # you can assign any name
  bucket_name            = "bucket-tf-controlplane-work-prod"     #you can use any name that has not been used globally for buckets
}

output "debug" {
  value     = module.objectstorage-bucket
  sensitive = true
}
