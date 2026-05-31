locals {
  node_definitions = var.proxmox_cluster.nodes
  cluster_options  = var.proxmox_cluster.options
  storage_password_keys = nonsensitive(
    keys(var.proxmox_cluster_secrets.storage_passwords)
  )

  managed_cluster_options = try(local.cluster_options.manage, true)

  managed_node_dns = {
    for node_name, node in local.node_definitions : node_name => node.dns
    if try(node.dns.manage, true) && try(node.dns.domain, null) != null
  }

  managed_node_time = {
    for node_name, node in local.node_definitions : node_name => node.time
    if try(node.time.manage, true) && try(node.time.time_zone, null) != null
  }

  managed_node_hosts = {
    for node_name, node in local.node_definitions : node_name => node.hosts
    if try(node.hosts.manage, false)
  }

  managed_node_firewalls = {
    for node_name, node in local.node_definitions : node_name => node.firewall
    if try(node.firewall.manage, false)
  }

  managed_bridges = merge({}, [
    for node_name, node in local.node_definitions : {
      for name, network in try(node.networks, {}) : "${node_name}/${name}" => merge(network, {
        name      = name
        node_name = node_name
      })
      if try(network.manage, false) && network.type == "linux_bridge"
    }
  ]...)

  managed_vlans = merge({}, [
    for node_name, node in local.node_definitions : {
      for name, network in try(node.networks, {}) : "${node_name}/${name}" => merge(network, {
        name      = name
        node_name = node_name
      })
      if try(network.manage, false) && network.type == "linux_vlan"
    }
  ]...)

  managed_pools = {
    for pool_id, pool in var.proxmox_cluster.pools : pool_id => pool
    if try(pool.manage, true)
  }

  managed_roles = {
    for role_id, role in var.proxmox_cluster.roles : role_id => role
    if try(role.manage, true)
  }

  managed_groups = {
    for group_id, group in var.proxmox_cluster.groups : group_id => group
    if try(group.manage, true)
  }

  managed_users = {
    for user_id, user in var.proxmox_cluster.users : user_id => user
    if try(user.manage, true)
  }

  managed_user_tokens = {
    for token_key, token in var.proxmox_cluster.user_tokens : token_key => token
    if try(token.manage, true)
  }

  managed_acls = {
    for acl in var.proxmox_cluster.acls :
    join("|", compact([
      acl.path,
      acl.role_id,
      acl.user_id,
      acl.group_id,
      acl.token_id,
    ])) => acl
    if try(acl.manage, true)
  }

  managed_acme_accounts = {
    for account_key, account in var.proxmox_cluster.acme.accounts : account_key => account
    if try(account.manage, true)
  }

  managed_acme_dns_plugins = {
    for plugin_key, plugin in var.proxmox_cluster.acme.dns_plugins : plugin_key => plugin
    if try(plugin.manage, true)
  }

  managed_acme_certificates = {
    for certificate_key, certificate in var.proxmox_cluster.acme.certificates : certificate_key => certificate
    if try(certificate.manage, true)
  }

  managed_directory_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "dir"
  }

  managed_lvm_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "lvm"
  }

  managed_lvmthin_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "lvmthin"
  }

  managed_zfspool_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "zfspool"
  }

  managed_nfs_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "nfs"
  }

  managed_cifs_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "cifs"
  }

  managed_pbs_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if try(storage.manage, true) && storage.type == "pbs"
  }

  observed_or_unsupported_storages = {
    for storage_id, storage in var.proxmox_cluster.storages : storage_id => storage
    if !contains(["dir", "lvm", "lvmthin", "zfspool", "nfs", "cifs", "pbs"], storage.type)
  }

  managed_backup_jobs = {
    for job_id, job in var.proxmox_cluster.backup_jobs : job_id => job
    if try(job.manage, true)
  }

  validation_errors = concat(
    [
      for storage_id, storage in local.managed_directory_storages :
      "Storage '${storage_id}' is type dir and must set path."
      if try(length(trimspace(storage.path)) == 0, true)
    ],
    [
      for storage_id, storage in local.managed_lvmthin_storages :
      "Storage '${storage_id}' is type lvmthin and must set volume_group and thin_pool."
      if try(length(trimspace(storage.volume_group)) == 0 || length(trimspace(storage.thin_pool)) == 0, true)
    ],
    [
      for storage_id, storage in local.managed_zfspool_storages :
      "Storage '${storage_id}' is type zfspool and must set zfs_pool."
      if try(length(trimspace(storage.zfs_pool)) == 0, true)
    ],
    [
      for storage_id, storage in local.managed_nfs_storages :
      "Storage '${storage_id}' is type nfs and must set server and export."
      if try(length(trimspace(storage.server)) == 0 || length(trimspace(storage.export)) == 0, true)
    ],
    [
      for storage_id, storage in local.managed_cifs_storages :
      "Storage '${storage_id}' is type cifs and must set server, share, username, and storage_passwords[storage_id]."
      if try(length(trimspace(storage.server)) == 0 || length(trimspace(storage.share)) == 0 || length(trimspace(storage.username)) == 0 || !contains(local.storage_password_keys, storage_id), true)
    ],
    [
      for storage_id, storage in local.managed_pbs_storages :
      "Storage '${storage_id}' is type pbs and must set server, datastore, username, and storage_passwords[storage_id]."
      if try(length(trimspace(storage.server)) == 0 || length(trimspace(storage.datastore)) == 0 || length(trimspace(storage.username)) == 0 || !contains(local.storage_password_keys, storage_id), true)
    ]
  )
}
