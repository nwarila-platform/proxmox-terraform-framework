output "cluster_summary" {
  description = "High-level declared cluster inventory."
  value = {
    name          = var.proxmox_cluster.name
    nodes         = keys(local.node_definitions)
    pools         = keys(var.proxmox_cluster.pools)
    roles         = keys(var.proxmox_cluster.roles)
    users         = keys(var.proxmox_cluster.users)
    storages      = keys(var.proxmox_cluster.storages)
    backup_jobs   = keys(var.proxmox_cluster.backup_jobs)
    acme_accounts = keys(var.proxmox_cluster.acme.accounts)
  }
}

output "provider_unsupported_cluster_options" {
  description = "Observed cluster options captured in tfvars but not currently managed by the pinned provider resource."
  value = merge(
    try(var.proxmox_cluster.options.provider_unsupported_settings, {}),
    length(try(var.proxmox_cluster.options.allowed_tags, [])) == 0 ? {} : {
      allowed_tags = var.proxmox_cluster.options.allowed_tags
    }
  )
}

output "observed_or_unsupported_storages" {
  description = "Storage entries captured for audit but not managed by the current provider resource set."
  value       = local.observed_or_unsupported_storages
}

output "observed_node_certificates" {
  description = "Observed node certificate metadata captured from the live cluster."
  value = {
    for node_name, node in local.node_definitions : node_name => node.observed_certificates
  }
}

output "acme_certificate_fingerprints" {
  description = "Fingerprints for ACME certificates managed by this framework."
  value = {
    for name, certificate in proxmox_virtual_environment_acme_certificate.certificate :
    name => certificate.fingerprint
  }
}

output "user_token_values" {
  description = "Newly created API token values. Store these immediately if any token resources are created."
  value = {
    for name, token in proxmox_virtual_environment_user_token.token :
    name => token.value
  }
  sensitive = true
}
