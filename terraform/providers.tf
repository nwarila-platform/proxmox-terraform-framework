provider "proxmox" {
  endpoint  = "https://${var.proxmox_cluster.endpoint.hostname}:${var.proxmox_cluster.endpoint.port}/api2/json"
  api_token = "${var.proxmox_cluster_secrets.api_token.id}=${var.proxmox_cluster_secrets.api_token.secret}"
  insecure  = var.proxmox_cluster.endpoint.skip_tls_verify
}
