module "iam" {
  source = "../iam"

  project_id = var.project_id
  name       = "sa-${substr(var.name, 0, 8)}-${substr(var.stage, 0, 8)}" #the name just only allow 20 characters

  role_assignment_role = var.role_assignment_role
}

module "dns_zone" {
  source = "../dns-zone"

  project_id = var.project_id
  name       = "dns-zone-${var.name}-${var.stage}"
  dns_name   = var.dns_name
}

module "secretsmanager" {
  source = "../secretsmanager"

  project_id = var.project_id
  name       = "secmgr-${var.name}-${var.stage}"
  acls       = var.acls

  users = var.users
}


module "ske_cluster" {
  source = "../ske-cluster"

  project_id             = var.project_id
  name                   = "ske-${substr(var.name, 0, 3)}-${substr(var.stage, 0, 3)}" #the name just only allow 11 characters
  region                 = var.region
  kubernetes_version_min = var.kubernetes_version_min

  node_pools = var.node_pools

  ### kubeconfig
  expiration = var.expiration
}
