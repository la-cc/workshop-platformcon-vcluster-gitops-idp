## Global variables
variable "project_id" {
  description = "STACKIT project ID"
  type        = string
}

variable "name" {
  description = "Name of the Secrets Manager instance"
  type        = string
}

variable "stage" {
  description = "Stage of the Secrets Manager instance"
  type        = string
}


### Secrets Manager variables
variable "acls" {
  description = "Set of CIDR blocks allowed to access this instance"
  type        = set(string)
  default     = ["0.0.0.0/0"]
}

variable "users" {
  description = <<EOF
List of users to create.
Each element must be an object with:
- description (string): human‐readable ID for the user
- write_enabled (bool): whether this user has write access
EOF
  type = list(object({
    description   = string
    write_enabled = bool
  }))
  default = []
}



### Kubernetes Engine variables
variable "kubernetes_version_min" {
  description = "Minimum Kubernetes version (e.g. \"1.31.4\"); uses latest if unset"
  type        = string
  default     = "1.31.4"
}

variable "node_pools" {
  description = <<EOF
List of node pools. Each element must be an object with:
- name               = string
- machine_type       = string
- os_version_min     = string
- minimum            = number
- maximum            = number
- availability_zones = list(string)
- labels             = map(string)
- taints             = list(object({
    key    = string
    value  = string
    effect = string
  }))
EOF
  type = list(object({
    name               = string
    machine_type       = string
    os_version_min     = string
    minimum            = number
    maximum            = number
    availability_zones = list(string)
    labels             = map(string)
    taints = list(object({
      key    = string
      value  = string
      effect = string
    }))
  }))
  default = []
}

#### Kubeconfig variables
variable "expiration" {
  description = "Expiration time for the kubeconfig in seconds"
  type        = number
  default     = 2629746 #1 month
}


### Bucket variables
variable "region" {
  description = "Region for all resources; defaults to provider region if unset"
  type        = string
  default     = "eu01"
}

### DNS Zone variables
variable "dns_name" {
  description = "DNS zone name (e.g. example) but it will created FQDN example.runs.onstackit.cloud"
  type        = string
}

variable "contact_email" {
  description = "Contact e-mail for the zone"
  type        = string
  default     = "artem.lajko@iits-consulting.de"
}


variable "description" {
  description = "DNS Zone for managing services running in the context of"
  type        = string
  default     = "DNS Zone for managing services running in the context of"
}

variable "type" {
  description = "Zone type: primary or secondary"
  type        = string
  default     = "primary"
}

### IAM variables
variable "role_assignment_role" {
  description = "Role to assign to the service account like owner, editor, viewer or dns.admin"
  type        = string
  default     = "dns.admin"
}
