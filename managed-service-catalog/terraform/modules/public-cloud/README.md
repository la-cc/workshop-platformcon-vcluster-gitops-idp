# STACKIT Public-Cloud Module

This Terraform module provisions a managed Kubernetes cluster using STACKIT Kubernetes Engine (SKE) in the STACKIT Public Cloud. 
In addition to the cluster, it also creates supporting resources such as a DNS zone and a secrets manager (Vault).

## Usage
```
module "public-cloud" {
    source = "../../modules/public-cloud"

    ### Global Variables
    project_id = "<your-project-id>"
    name       = "<cluster-name>"
    stage      = "<stage like dev, prod, test>"
    
    
    ### DNS ZONE
    dns_name      = "<dnsname-replaceme>.runs.onstackit.cloud"
    contact_email = "hello@demo.de"


    ### Kubernetes Instance variables
    kubernetes_version_min = "1.31.8"

    node_pools = [

        {
            availability_zones = ["eu01-2"]
            machine_type       = "c1.2"
            maximum            = 2
            minimum            = 1
            name               = "pool-infra"
            os_version_min     = "4152.2.0"

            labels = {
                "project" = "public-cloud-demo"
                "role"    = "infra"
            }

            taints = []
        }
    ]

    ### SECRET MANAGER USERS
    users = [
        {
            description   = "vault-user-rw"
            write_enabled = true
        },
        {
            description   = "vault-user-ro"
            write_enabled = false
        }
    ]
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_stackit"></a> [stackit](#requirement\_stackit) | 0.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dns_zone"></a> [dns\_zone](#module\_dns\_zone) | ../dns-zone | n/a |
| <a name="module_iam"></a> [iam](#module\_iam) | ../iam | n/a |
| <a name="module_secretsmanager"></a> [secretsmanager](#module\_secretsmanager) | ../secretsmanager | n/a |
| <a name="module_ske_cluster"></a> [ske\_cluster](#module\_ske\_cluster) | ../ske-cluster | n/a |

## Resources

| Name | Type |
|------|------|
| [vault_kv_secret_v2.cluster_secrets](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |
| [vault_kv_secret_v2.dns_zone_admin](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acls"></a> [acls](#input\_acls) | Set of CIDR blocks allowed to access this instance | `set(string)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_contact_email"></a> [contact\_email](#input\_contact\_email) | Contact e-mail for the zone | `string` | `"artem.lajko@iits-consulting.de"` | no |
| <a name="input_description"></a> [description](#input\_description) | DNS Zone for managing services running in the context of | `string` | `"DNS Zone for managing services running in the context of"` | no |
| <a name="input_dns_name"></a> [dns\_name](#input\_dns\_name) | DNS zone name (e.g. example) but it will created FQDN example.runs.onstackit.cloud | `string` | n/a | yes |
| <a name="input_expiration"></a> [expiration](#input\_expiration) | Expiration time for the kubeconfig in seconds | `number` | `2629746` | no |
| <a name="input_kubernetes_version_min"></a> [kubernetes\_version\_min](#input\_kubernetes\_version\_min) | Minimum Kubernetes version (e.g. "1.31.4"); uses latest if unset | `string` | `"1.31.4"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Secrets Manager instance | `string` | n/a | yes |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | List of node pools. Each element must be an object with:<br/>- name               = string<br/>- machine\_type       = string<br/>- os\_version\_min     = string<br/>- minimum            = number<br/>- maximum            = number<br/>- availability\_zones = list(string)<br/>- labels             = map(string)<br/>- taints             = list(object({<br/>    key    = string<br/>    value  = string<br/>    effect = string<br/>  })) | <pre>list(object({<br/>    name               = string<br/>    machine_type       = string<br/>    os_version_min     = string<br/>    minimum            = number<br/>    maximum            = number<br/>    availability_zones = list(string)<br/>    labels             = map(string)<br/>    taints = list(object({<br/>      key    = string<br/>      value  = string<br/>      effect = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | STACKIT project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for all resources; defaults to provider region if unset | `string` | `"eu01"` | no |
| <a name="input_role_assignment_role"></a> [role\_assignment\_role](#input\_role\_assignment\_role) | Role to assign to the service account like owner, editor, viewer or dns.admin | `string` | `"dns.admin"` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage of the Secrets Manager instance | `string` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Zone type: primary or secondary | `string` | `"primary"` | no |
| <a name="input_users"></a> [users](#input\_users) | List of users to create.<br/>Each element must be an object with:<br/>- description (string): human‐readable ID for the user<br/>- write\_enabled (bool): whether this user has write access | <pre>list(object({<br/>    description   = string<br/>    write_enabled = bool<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig_raw"></a> [kubeconfig\_raw](#output\_kubeconfig\_raw) | Raw admin kubeconfig (short-lived, sensitive) |
| <a name="output_vault_instance_id"></a> [vault\_instance\_id](#output\_vault\_instance\_id) | ID of the created Secrets Manager instance. Needed or named as path for/in External Secrets |
| <a name="output_vault_user_ro_name"></a> [vault\_user\_ro\_name](#output\_vault\_user\_ro\_name) | User name of the vault-user-ro |
| <a name="output_vault_user_ro_password"></a> [vault\_user\_ro\_password](#output\_vault\_user\_ro\_password) | Password of the vault-user-ro |
<!-- END_TF_DOCS -->