resource "stackit_service_account" "this" {
  project_id = var.project_id
  name       = var.name
}

resource "stackit_service_account_access_token" "this" {
  project_id            = var.project_id
  service_account_email = stackit_service_account.this.email
  ttl_days              = var.ttl_days

}


resource "stackit_authorization_project_role_assignment" "this" {

  resource_id = var.project_id
  role        = var.role_assignment_role
  subject     = stackit_service_account.this.email
}
