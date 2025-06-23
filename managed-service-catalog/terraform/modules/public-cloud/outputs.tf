### Secrets Manager Instance
### Secrets Manager Instance
output "vault_user_rw_password" {
  description = "Password of the vault-user-ro"
  value       = module.secretsmanager.users["vault-user-rw"].password
  sensitive   = true
}

output "vault_user_rw_name" {
  description = "User name of the vault-user-ro"
  value       = module.secretsmanager.users["vault-user-rw"].username
}

output "vault_user_ro_password_b64" {
  description = "Base64-encoded password of vault-user-ro"
  value       = base64encode(module.secretsmanager.users["vault-user-ro"].password)
  sensitive   = true
}

output "vault_user_ro_name_b64" {
  description = "Base64-encoded username of vault-user-ro"
  value       = base64encode(module.secretsmanager.users["vault-user-ro"].username)
}
output "vault_instance_id" {
  description = "ID of the created Secrets Manager instance. Needed or named as path for/in External Secrets"
  value       = module.secretsmanager.instance_id
}

### Kubernetes Instance
output "kubeconfig_raw" {
  description = "Raw admin kubeconfig (short-lived, sensitive)"
  value       = module.ske_cluster.kubeconfig_raw
  sensitive   = true
}
