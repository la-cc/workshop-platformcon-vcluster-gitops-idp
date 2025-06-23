terraform {
  required_providers {
    terraform = {
      source = "terraform.io/builtin/terraform"
    }
    stackit = {
      source  = "stackitcloud/stackit"
      version = "0.51.0"
    }
  }
}

provider "stackit" {
  experiments           = ["iam"]
  enable_beta_resources = true

}


provider "vault" {
  address          = "https://prod.sm.eu01.stackit.cloud"
  skip_child_token = true

  auth_login_userpass {
    username = module.secretsmanager.users["vault-user-rw"].username
    password = module.secretsmanager.users["vault-user-rw"].password
  }
}


provider "aws" {
  region                      = var.region
  skip_credentials_validation = true
  skip_region_validation      = true
  skip_requesting_account_id  = true
  access_key                  = module.objectstorage_bucket.credential_access_key
  secret_key                  = module.objectstorage_bucket.credential_secret_access_key
  endpoints {
    s3 = "https://object.storage.eu01.onstackit.cloud"
  }
}
