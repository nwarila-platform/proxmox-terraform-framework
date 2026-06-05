resource "terraform_data" "framework_validation" {
  input = "proxmox-cluster-framework-validation"

  lifecycle {
    ignore_changes = [input]

    precondition {
      condition     = length(local.validation_errors) == 0
      error_message = nonsensitive("Framework validation failed:\n\n${join("\n\n", local.validation_errors)}")
    }
  }
}

resource "proxmox_virtual_environment_cluster_options" "this" {
  count = local.managed_cluster_options ? 1 : 0

  bandwidth_limit_clone     = local.cluster_options.bandwidth_limit_clone
  bandwidth_limit_default   = local.cluster_options.bandwidth_limit_default
  bandwidth_limit_migration = local.cluster_options.bandwidth_limit_migration
  bandwidth_limit_move      = local.cluster_options.bandwidth_limit_move
  bandwidth_limit_restore   = local.cluster_options.bandwidth_limit_restore
  console                   = local.cluster_options.console
  crs_ha                    = local.cluster_options.crs_ha
  crs_ha_rebalance_on_start = local.cluster_options.crs_ha_rebalance_on_start
  description               = local.cluster_options.description
  email_from                = local.cluster_options.email_from
  ha_shutdown_policy        = local.cluster_options.ha_shutdown_policy
  http_proxy                = local.cluster_options.http_proxy
  keyboard                  = local.cluster_options.keyboard
  language                  = local.cluster_options.language
  mac_prefix                = local.cluster_options.mac_prefix
  max_workers               = local.cluster_options.max_workers
  migration_cidr            = local.cluster_options.migration_cidr
  migration_type            = local.cluster_options.migration_type
  next_id                   = local.cluster_options.next_id
  notify                    = local.cluster_options.notify
}

resource "proxmox_virtual_environment_dns" "node" {
  for_each = local.managed_node_dns

  node_name = each.key
  domain    = each.value.domain
  servers   = each.value.servers
}

resource "proxmox_virtual_environment_time" "node" {
  for_each = local.managed_node_time

  node_name = each.key
  time_zone = each.value.time_zone
}

resource "proxmox_virtual_environment_hosts" "node" {
  for_each = local.managed_node_hosts

  node_name = each.key

  dynamic "entry" {
    for_each = each.value.entries

    content {
      address   = entry.value.address
      hostnames = entry.value.hostnames
    }
  }
}

resource "proxmox_virtual_environment_node_firewall" "node" {
  for_each = local.managed_node_firewalls

  node_name                            = each.key
  enabled                              = each.value.enabled
  log_level_forward                    = each.value.log_level_forward
  log_level_in                         = each.value.log_level_in
  log_level_out                        = each.value.log_level_out
  ndp                                  = each.value.ndp
  nf_conntrack_max                     = each.value.nf_conntrack_max
  nf_conntrack_tcp_timeout_established = each.value.nf_conntrack_tcp_timeout_established
  nftables                             = each.value.nftables
  nosmurfs                             = each.value.nosmurfs
  smurf_log_level                      = each.value.smurf_log_level
  tcp_flags_log_level                  = each.value.tcp_flags_log_level

}

resource "proxmox_virtual_environment_network_linux_bridge" "bridge" {
  for_each = local.managed_bridges

  name           = each.value.name
  node_name      = each.value.node_name
  address        = each.value.address
  address6       = each.value.address6
  autostart      = each.value.autostart
  comment        = each.value.comment
  gateway        = each.value.gateway
  gateway6       = each.value.gateway6
  mtu            = each.value.mtu
  timeout_reload = each.value.timeout_reload
  vids           = each.value.vids
  vlan_aware     = each.value.vlan_aware

  lifecycle {
    ignore_changes = [ports]
  }
}

resource "proxmox_virtual_environment_network_linux_vlan" "vlan" {
  for_each = local.managed_vlans

  name           = each.value.name
  node_name      = each.value.node_name
  address        = each.value.address
  address6       = each.value.address6
  autostart      = each.value.autostart
  comment        = each.value.comment
  gateway        = each.value.gateway
  gateway6       = each.value.gateway6
  interface      = each.value.interface
  mtu            = each.value.mtu
  timeout_reload = each.value.timeout_reload
  vlan           = each.value.vlan
}

resource "proxmox_virtual_environment_pool" "pool" {
  for_each = local.managed_pools

  pool_id = each.key
  comment = each.value.comment
}

resource "proxmox_virtual_environment_role" "role" {
  for_each = local.managed_roles

  role_id    = each.key
  privileges = each.value.privileges
}

resource "proxmox_virtual_environment_group" "group" {
  for_each = local.managed_groups

  group_id = each.key
  comment  = each.value.comment

  dynamic "acl" {
    for_each = each.value.acl

    content {
      path      = acl.value.path
      propagate = acl.value.propagate
      role_id   = acl.value.role_id
    }
  }

  lifecycle {
    ignore_changes = [acl]
  }
}

resource "proxmox_virtual_environment_user" "user" {
  for_each = local.managed_users

  user_id         = each.key
  comment         = each.value.comment
  email           = each.value.email
  enabled         = each.value.enabled
  expiration_date = each.value.expiration_date
  first_name      = each.value.first_name
  groups          = each.value.groups
  keys            = each.value.keys
  last_name       = each.value.last_name
  password        = lookup(var.proxmox_cluster_secrets.user_passwords, each.key, null)

  dynamic "acl" {
    for_each = each.value.acl

    content {
      path      = acl.value.path
      propagate = acl.value.propagate
      role_id   = acl.value.role_id
    }
  }

  lifecycle {
    ignore_changes = [acl]
  }
}

resource "proxmox_virtual_environment_user_token" "token" {
  for_each = local.managed_user_tokens

  user_id               = each.value.user_id
  token_name            = each.value.token_name
  comment               = each.value.comment
  expiration_date       = each.value.expiration_date
  privileges_separation = each.value.privileges_separation
}

resource "proxmox_virtual_environment_acl" "acl" {
  for_each = local.managed_acls

  path      = each.value.path
  propagate = each.value.propagate
  role_id   = each.value.role_id
  user_id   = each.value.user_id
  group_id  = each.value.group_id
  token_id  = each.value.token_id
}

resource "proxmox_virtual_environment_acme_account" "account" {
  for_each = local.managed_acme_accounts

  contact      = each.value.contact
  directory    = each.value.directory
  eab_hmac_key = each.value.eab_hmac_key
  eab_kid      = each.value.eab_kid
  name         = each.value.name
  tos          = each.value.tos
}

resource "proxmox_virtual_environment_acme_dns_plugin" "dns_plugin" {
  for_each = local.managed_acme_dns_plugins

  api              = each.value.api
  data             = merge(each.value.data, lookup(var.proxmox_cluster_secrets.acme_dns_plugin_sensitive_data, each.key, {}))
  disable          = each.value.disable
  plugin           = each.value.plugin
  validation_delay = each.value.validation_delay
}

resource "proxmox_virtual_environment_acme_certificate" "certificate" {
  for_each = local.managed_acme_certificates

  account   = each.value.account
  domains   = each.value.domains
  force     = each.value.force
  node_name = each.value.node_name
}

resource "proxmox_virtual_environment_storage_directory" "directory" {
  for_each = local.managed_directory_storages

  id            = each.key
  content       = each.value.content
  disable       = each.value.disable
  nodes         = each.value.nodes
  path          = each.value.path
  preallocation = each.value.preallocation
  shared        = each.value.shared

  dynamic "backups" {
    for_each = each.value.backups == null ? [] : [each.value.backups]

    content {
      keep_all              = backups.value.keep_all
      keep_daily            = backups.value.keep_daily
      keep_hourly           = backups.value.keep_hourly
      keep_last             = backups.value.keep_last
      keep_monthly          = backups.value.keep_monthly
      keep_weekly           = backups.value.keep_weekly
      keep_yearly           = backups.value.keep_yearly
      max_protected_backups = backups.value.max_protected_backups
    }
  }
}

resource "proxmox_virtual_environment_storage_lvm" "lvm" {
  for_each = local.managed_lvm_storages

  id           = each.key
  content      = each.value.content
  disable      = each.value.disable
  nodes        = each.value.nodes
  shared       = each.value.shared
  volume_group = each.value.volume_group
}

resource "proxmox_virtual_environment_storage_lvmthin" "lvmthin" {
  for_each = local.managed_lvmthin_storages

  id           = each.key
  content      = each.value.content
  disable      = each.value.disable
  nodes        = each.value.nodes
  thin_pool    = each.value.thin_pool
  volume_group = each.value.volume_group
}

resource "proxmox_virtual_environment_storage_zfspool" "zfspool" {
  for_each = local.managed_zfspool_storages

  id             = each.key
  blocksize      = each.value.blocksize
  content        = each.value.content
  disable        = each.value.disable
  nodes          = each.value.nodes
  thin_provision = each.value.thin_provision
  zfs_pool       = each.value.zfs_pool
}

resource "proxmox_virtual_environment_storage_nfs" "nfs" {
  for_each = local.managed_nfs_storages

  id            = each.key
  content       = each.value.content
  disable       = each.value.disable
  export        = each.value.export
  nodes         = each.value.nodes
  options       = each.value.options
  preallocation = each.value.preallocation
  server        = each.value.server

  dynamic "backups" {
    for_each = each.value.backups == null ? [] : [each.value.backups]

    content {
      keep_all              = backups.value.keep_all
      keep_daily            = backups.value.keep_daily
      keep_hourly           = backups.value.keep_hourly
      keep_last             = backups.value.keep_last
      keep_monthly          = backups.value.keep_monthly
      keep_weekly           = backups.value.keep_weekly
      keep_yearly           = backups.value.keep_yearly
      max_protected_backups = backups.value.max_protected_backups
    }
  }
}

resource "proxmox_virtual_environment_storage_cifs" "cifs" {
  for_each = local.managed_cifs_storages

  id            = each.key
  content       = each.value.content
  disable       = each.value.disable
  domain        = each.value.domain
  nodes         = each.value.nodes
  password      = var.proxmox_cluster_secrets.storage_passwords[each.key]
  preallocation = each.value.preallocation
  server        = each.value.server
  share         = each.value.share
  subdirectory  = each.value.subdirectory
  username      = each.value.username

  dynamic "backups" {
    for_each = each.value.backups == null ? [] : [each.value.backups]

    content {
      keep_all              = backups.value.keep_all
      keep_daily            = backups.value.keep_daily
      keep_hourly           = backups.value.keep_hourly
      keep_last             = backups.value.keep_last
      keep_monthly          = backups.value.keep_monthly
      keep_weekly           = backups.value.keep_weekly
      keep_yearly           = backups.value.keep_yearly
      max_protected_backups = backups.value.max_protected_backups
    }
  }
}

resource "proxmox_virtual_environment_storage_pbs" "pbs" {
  for_each = local.managed_pbs_storages

  id                      = each.key
  content                 = each.value.content
  datastore               = each.value.datastore
  disable                 = each.value.disable
  encryption_key          = lookup(var.proxmox_cluster_secrets.storage_encryption_keys, each.key, null)
  fingerprint             = each.value.fingerprint
  generate_encryption_key = each.value.generate_encryption_key
  namespace               = each.value.namespace
  nodes                   = each.value.nodes
  password                = var.proxmox_cluster_secrets.storage_passwords[each.key]
  server                  = each.value.server
  username                = each.value.username

  dynamic "backups" {
    for_each = each.value.backups == null ? [] : [each.value.backups]

    content {
      keep_all              = backups.value.keep_all
      keep_daily            = backups.value.keep_daily
      keep_hourly           = backups.value.keep_hourly
      keep_last             = backups.value.keep_last
      keep_monthly          = backups.value.keep_monthly
      keep_weekly           = backups.value.keep_weekly
      keep_yearly           = backups.value.keep_yearly
      max_protected_backups = backups.value.max_protected_backups
    }
  }
}

resource "proxmox_backup_job" "job" {
  for_each = local.managed_backup_jobs

  id                        = each.key
  all                       = each.value.all
  bwlimit                   = each.value.bwlimit
  compress                  = each.value.compress
  enabled                   = each.value.enabled
  exclude_path              = each.value.exclude_path
  fleecing                  = each.value.fleecing
  ionice                    = each.value.ionice
  lockwait                  = each.value.lockwait
  mailnotification          = each.value.mailnotification
  mailto                    = each.value.mailto
  maxfiles                  = each.value.maxfiles
  mode                      = each.value.mode
  node                      = each.value.node
  notes_template            = each.value.notes_template
  pbs_change_detection_mode = each.value.pbs_change_detection_mode
  performance               = each.value.performance
  pigz                      = each.value.pigz
  pool                      = each.value.pool
  protected                 = each.value.protected
  prune_backups             = each.value.prune_backups
  remove                    = each.value.remove
  repeat_missed             = each.value.repeat_missed
  schedule                  = each.value.schedule
  script                    = each.value.script
  starttime                 = each.value.starttime
  stdexcludes               = each.value.stdexcludes
  stopwait                  = each.value.stopwait
  storage                   = each.value.storage
  tmpdir                    = each.value.tmpdir
  vmid                      = each.value.vmid
  zstd                      = each.value.zstd
}

resource "proxmox_virtual_environment_cluster_firewall" "this" {
  count = try(var.proxmox_cluster.firewall.manage, false) ? 1 : 0

  ebtables       = var.proxmox_cluster.firewall.ebtables
  enabled        = var.proxmox_cluster.firewall.enabled
  forward_policy = var.proxmox_cluster.firewall.forward_policy
  input_policy   = var.proxmox_cluster.firewall.input_policy
  output_policy  = var.proxmox_cluster.firewall.output_policy

  dynamic "log_ratelimit" {
    for_each = var.proxmox_cluster.firewall.log_ratelimit

    content {
      burst   = log_ratelimit.value.burst
      enabled = log_ratelimit.value.enabled
      rate    = log_ratelimit.value.rate
    }
  }

  lifecycle {
    ignore_changes = [
      ebtables,
      enabled,
      forward_policy,
      input_policy,
      output_policy,
      log_ratelimit,
    ]
  }
}
