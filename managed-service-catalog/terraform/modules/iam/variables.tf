variable "project_id" {
  description = "STACKIT project ID where the service account will be created"
  type        = string
}

variable "name" {
  description = "Name of the service account (max 30 chars; lowercase alphanumeric and hyphens only)"
  type        = string

  validation {
    condition     = length(var.name) <= 30
    error_message = "Service account name must not exceed 30 characters."
  }
}

variable "ttl_days" {
  description = "Token time-to-live in days"
  type        = number
  default     = 90
}



### IAM Project Role Assignment
variable "role_assignment_resource_id" {
  description = "The ID of the project (or other resource) to which the role will be assigned."
  type        = string
  default     = ""
}

variable "role_assignment_role" {
  description = "The name of the role to assign (e.g. owner, editor, viewer)."
  type        = string
}

variable "role_assignment_subject" {
  description = "The identifier of the user, service account, or client (usually an email or name)."
  type        = string
  default     = ""
}

