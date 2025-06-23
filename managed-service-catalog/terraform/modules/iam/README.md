# STACKIT IAM Module

Creates a STACKIT Service Account and an Access Token, with optional rotation trigger.

## Usage

module "service_account" {
  source = "../modules/iam"

  project_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  name       = "sa01"

  # Optional: override default TTL
  ttl_days   = 180

}

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_stackit"></a> [stackit](#requirement\_stackit) | >= 0.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_stackit"></a> [stackit](#provider\_stackit) | >= 0.51.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [stackit_authorization_project_role_assignment.this](https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs/resources/authorization_project_role_assignment) | resource |
| [stackit_service_account.this](https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs/resources/service_account) | resource |
| [stackit_service_account_access_token.this](https://registry.terraform.io/providers/stackitcloud/stackit/latest/docs/resources/service_account_access_token) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the service account (max 30 chars; lowercase alphanumeric and hyphens only) | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | STACKIT project ID where the service account will be created | `string` | n/a | yes |
| <a name="input_role_assignment_resource_id"></a> [role\_assignment\_resource\_id](#input\_role\_assignment\_resource\_id) | The ID of the project (or other resource) to which the role will be assigned. | `string` | `""` | no |
| <a name="input_role_assignment_role"></a> [role\_assignment\_role](#input\_role\_assignment\_role) | The name of the role to assign (e.g. owner, editor, viewer). | `string` | n/a | yes |
| <a name="input_role_assignment_subject"></a> [role\_assignment\_subject](#input\_role\_assignment\_subject) | The identifier of the user, service account, or client (usually an email or name). | `string` | `""` | no |
| <a name="input_ttl_days"></a> [ttl\_days](#input\_ttl\_days) | Token time-to-live in days | `number` | `90` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_token"></a> [access\_token](#output\_access\_token) | JWT access token (sensitive) |
| <a name="output_access_token_id"></a> [access\_token\_id](#output\_access\_token\_id) | Internal ID of the access token |
| <a name="output_role_assignment_id"></a> [role\_assignment\_id](#output\_role\_assignment\_id) | The ID of the created project role assignment. |
| <a name="output_role_assignment_resource_id"></a> [role\_assignment\_resource\_id](#output\_role\_assignment\_resource\_id) | The resource ID to which the role was applied. |
| <a name="output_role_assignment_role"></a> [role\_assignment\_role](#output\_role\_assignment\_role) | The role that was assigned. |
| <a name="output_role_assignment_subject"></a> [role\_assignment\_subject](#output\_role\_assignment\_subject) | The subject (user/service account/client) that received the role. |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Email address of the service account |
| <a name="output_service_account_id"></a> [service\_account\_id](#output\_service\_account\_id) | Internal ID of the service account (project\_id,email) |
<!-- END_TF_DOCS -->