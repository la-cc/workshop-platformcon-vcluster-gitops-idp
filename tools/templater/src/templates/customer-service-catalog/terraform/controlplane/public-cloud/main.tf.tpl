terraform {
  required_version = ">=1.9.3"
  backend "s3" {
    bucket = "bucket-tf-controlplane-work-prod"
    key    = "tf-state-controlplane-work-prod"
    endpoints = {
      s3 = "https://object.storage.eu01.onstackit.cloud"
    }
    region                      = "eu01"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    skip_requesting_account_id  = true
  }
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


module "public-cloud" {
  source = "../../../../managed-service-catalog/terraform/modules/public-cloud"

  ### Global Variables
  project_id = "38867e9e-b5d4-4a85-97a8-0a944ab75b19"
  name       = "controlplane"
  stage      = "prod"


  ### DNS ZONE
  dns_name      = "platformcon.stackit.run"
  contact_email = "artem.lajko@iits-consulting.de"


  ### Kubernetes Instance variables
  kubernetes_version_min = "1.32.5"

  node_pools = [

    {
      availability_zones = ["eu01-2"]
      machine_type       = "c1.4"
      maximum            = 4
      minimum            = 2
      name               = "pool-infra"
      os_version_min     = "4152.2.3"

      labels = {
        "project" = "public-cloud-workshop"
        "role"    = "infra"
      }

      taints = [
        {
          key    = "role"
          value  = "infra"
          effect = "NoSchedule"
        }
      ]
    },

    {
      availability_zones = ["eu01-2"]
      machine_type       = "c1.4"
      maximum            = 4
      minimum            = 2
      name               = "pool-shared"
      os_version_min     = "4152.2.3"

      labels = {
        "project" = "public-cloud-workshop"
        "role"    = "app"
      }

      taints = []
    },

{%- for cluster in clusters %}
  {%- set has_isolated_nodepools = cluster.nodePools | selectattr("isolated", "equalto", true) | list %}
  {%- if has_isolated_nodepools %}
    {%- for nodepool in has_isolated_nodepools %}
  {
    availability_zones = {{ nodepool.availability_zones | tojson }},
    machine_type       = "{{ nodepool.machine_type }}",
    maximum            = {{ nodepool.maximum }},
    minimum            = {{ nodepool.minimum }},
    name               = "pool-{% if nodepool.name is defined and nodepool.name|length > 0 %}{{ nodepool.name }}{% else %}{{ cluster.project }}{% endif %}",
    os_version_min     = "{{ nodepool.os_version_min }}",

    labels = {
      {%- if nodepool.labels is defined and nodepool.labels|length > 0 %}
        {%- for key, value in nodepool.labels.items() %}
          "{{ key }}" = "{{ value }}"{% if not loop.last %}, {% endif %}
        {%- endfor %}
      {%- else %}
          "project" = "{{ cluster.project }}"
      {%- endif %}
    },

    taints = [
      {%- if nodepool.taints is defined and nodepool.taints|length > 0 %}
        {%- for taint in nodepool.taints %}
          {
            key    = "{{ taint.key }}",
            value  = "{{ taint.value }}",
            effect = "{{ taint.effect }}"
          }{% if not loop.last %}, {% endif %}
        {%- endfor %}
      {%- else %}
          {
            key    = "project",
            value  = "{{ cluster.project }}",
            effect = "NoSchedule"
          }
      {%- endif %}
    ]
  }{% if not loop.last %}, {% endif %}
    {%- endfor %}
  {%- endif %}
  {%- if not loop.last %}, {% endif %}
{%- endfor %}


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

output "debug" {
  value     = module.public-cloud
  sensitive = true
}

output "kubeconfig_raw" {
  value     = module.public-cloud.kubeconfig_raw
  sensitive = true
}
