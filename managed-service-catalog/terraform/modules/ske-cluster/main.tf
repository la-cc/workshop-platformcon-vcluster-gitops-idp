resource "stackit_ske_cluster" "this" {
  project_id             = var.project_id
  name                   = var.name
  region                 = var.region
  kubernetes_version_min = var.kubernetes_version_min

  lifecycle {
    ignore_changes = [
      kubernetes_version_used,
      egress_address_ranges
    ]
  }
  node_pools = var.node_pools
}

resource "stackit_ske_kubeconfig" "this" {
  project_id   = var.project_id
  cluster_name = stackit_ske_cluster.this.name
  refresh      = var.refresh
  expiration   = var.expiration
}


resource "local_file" "kubeconfig" {
  count           = var.create_kubeconfig_local ? 1 : 0
  content         = stackit_ske_kubeconfig.this.kube_config
  filename        = var.kubeconfig_path
  file_permission = "0644"

  depends_on = [stackit_ske_kubeconfig.this]
}
