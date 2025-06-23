output "service_account_id" {
  description = "Internal ID of the service account (project_id,email)"
  value       = stackit_service_account.this.id
}

output "service_account_email" {
  description = "Email address of the service account"
  value       = stackit_service_account.this.email
}

output "access_token_id" {
  description = "Internal ID of the access token"
  value       = stackit_service_account_access_token.this.access_token_id
}

output "access_token" {
  description = "JWT access token (sensitive)"
  value       = stackit_service_account_access_token.this.token
  sensitive   = true
}

### Role Assignment Outputs
output "role_assignment_id" {
  description = "The ID of the created project role assignment."
  value       = stackit_authorization_project_role_assignment.this.id
}

output "role_assignment_resource_id" {
  description = "The resource ID to which the role was applied."
  value       = stackit_authorization_project_role_assignment.this.resource_id
}

output "role_assignment_role" {
  description = "The role that was assigned."
  value       = stackit_authorization_project_role_assignment.this.role
}

output "role_assignment_subject" {
  description = "The subject (user/service account/client) that received the role."
  value       = stackit_authorization_project_role_assignment.this.subject
}

