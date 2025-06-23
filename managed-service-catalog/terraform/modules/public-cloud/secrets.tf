resource "vault_kv_secret_v2" "cluster_secrets" {
  mount = module.secretsmanager.instance_id
  name  = "cluster_secrets"

  data_json = jsonencode({
    vault_instance = {
      api_url     = "https://prod.sm.eu01.stackit.cloud"
      instance_id = module.secretsmanager.instance_id
      password    = module.secretsmanager.users["vault-user-ro"].password
      username    = module.secretsmanager.users["vault-user-ro"].username
      user_id     = module.secretsmanager.users["vault-user-ro"].user_id
    }
  })
}


resource "vault_kv_secret_v2" "dns_zone_admin" {
  mount = module.secretsmanager.instance_id
  name  = "dns_zone_admin"
  data_json = jsonencode({
    auth_token = module.iam.access_token
    project_id = var.project_id
    zone_id    = module.dns_zone.zone_id
    dns_name   = module.dns_zone.name
  })
}

