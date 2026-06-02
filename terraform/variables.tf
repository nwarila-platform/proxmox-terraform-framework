#region ------ [ Proxmox Cluster ] ---------------------------------------------------------- #

variable "proxmox_cluster" {
  description = "Declarative Proxmox cluster state. This is the primary non-secret adoption contract for the cluster."

  type = object({
    endpoint = object({
      hostname        = string
      port            = optional(number, 8006)
      skip_tls_verify = optional(bool, false)
    })

    name = optional(string)

    options = optional(object({
      manage                        = optional(bool, true)
      allowed_tags                  = optional(list(string), [])
      bandwidth_limit_clone         = optional(number)
      bandwidth_limit_default       = optional(number)
      bandwidth_limit_migration     = optional(number)
      bandwidth_limit_move          = optional(number)
      bandwidth_limit_restore       = optional(number)
      console                       = optional(string)
      crs_ha                        = optional(string)
      crs_ha_rebalance_on_start     = optional(bool)
      description                   = optional(string)
      email_from                    = optional(string)
      ha_shutdown_policy            = optional(string)
      http_proxy                    = optional(string)
      keyboard                      = optional(string)
      language                      = optional(string)
      mac_prefix                    = optional(string)
      max_workers                   = optional(number)
      migration_cidr                = optional(string)
      migration_type                = optional(string)
      provider_unsupported_settings = optional(map(any), {})

      next_id = optional(object({
        lower = optional(number)
        upper = optional(number)
      }))

      notify = optional(object({
        ha_fencing_mode        = optional(string)
        ha_fencing_target      = optional(string)
        package_updates        = optional(string)
        package_updates_target = optional(string)
        replication            = optional(string)
        replication_target     = optional(string)
      }))
    }), {})

    nodes = optional(map(object({
      address = optional(string)

      dns = optional(object({
        manage  = optional(bool, true)
        domain  = string
        servers = optional(list(string), [])
      }))

      time = optional(object({
        manage    = optional(bool, true)
        time_zone = string
      }))

      hosts = optional(object({
        manage = optional(bool, false)
        entries = optional(list(object({
          address   = string
          hostnames = list(string)
        })), [])
      }))

      firewall = optional(object({
        manage                               = optional(bool, false)
        enabled                              = optional(bool)
        log_level_forward                    = optional(string)
        log_level_in                         = optional(string)
        log_level_out                        = optional(string)
        ndp                                  = optional(bool)
        nf_conntrack_max                     = optional(number)
        nf_conntrack_tcp_timeout_established = optional(number)
        nftables                             = optional(bool)
        nosmurfs                             = optional(bool)
        smurf_log_level                      = optional(string)
        tcp_flags_log_level                  = optional(string)
      }))

      networks = optional(map(object({
        manage         = optional(bool, false)
        type           = string
        address        = optional(string)
        address6       = optional(string)
        autostart      = optional(bool)
        comment        = optional(string)
        gateway        = optional(string)
        gateway6       = optional(string)
        interface      = optional(string)
        mtu            = optional(number)
        ports          = optional(list(string), [])
        timeout_reload = optional(number)
        vids           = optional(string)
        vlan           = optional(number)
        vlan_aware     = optional(bool)
      })), {})

      observed_certificates = optional(map(object({
        subject                   = optional(string)
        subject_alternative_names = optional(list(string), [])
        fingerprint               = optional(string)
        not_after                 = optional(string)
      })), {})

      apt_standard_repositories = optional(map(object({
        manage = optional(bool, false)
        handle = string
      })), {})
    })), {})

    pools = optional(map(object({
      manage  = optional(bool, true)
      comment = optional(string)
    })), {})

    roles = optional(map(object({
      manage     = optional(bool, true)
      privileges = set(string)
    })), {})

    groups = optional(map(object({
      manage  = optional(bool, true)
      comment = optional(string)

      acl = optional(list(object({
        path      = string
        propagate = optional(bool, true)
        role_id   = string
      })), [])
    })), {})

    users = optional(map(object({
      manage          = optional(bool, true)
      comment         = optional(string)
      email           = optional(string)
      enabled         = optional(bool, true)
      expiration_date = optional(string)
      first_name      = optional(string)
      groups          = optional(set(string), [])
      keys            = optional(string)
      last_name       = optional(string)

      acl = optional(list(object({
        path      = string
        propagate = optional(bool, true)
        role_id   = string
      })), [])
    })), {})

    user_tokens = optional(map(object({
      manage                = optional(bool, true)
      user_id               = string
      token_name            = string
      comment               = optional(string)
      expiration_date       = optional(string)
      privileges_separation = optional(bool, true)
    })), {})

    acls = optional(list(object({
      manage    = optional(bool, true)
      path      = string
      role_id   = string
      propagate = optional(bool, true)
      user_id   = optional(string)
      group_id  = optional(string)
      token_id  = optional(string)
    })), [])

    acme = optional(object({
      observed_plugins = optional(map(object({
        type             = optional(string)
        api              = optional(string)
        disable          = optional(bool)
        validation_delay = optional(number)
      })), {})

      accounts = optional(map(object({
        manage       = optional(bool, true)
        contact      = string
        directory    = optional(string)
        eab_hmac_key = optional(string)
        eab_kid      = optional(string)
        name         = optional(string)
        tos          = optional(string)
      })), {})

      dns_plugins = optional(map(object({
        manage           = optional(bool, true)
        api              = string
        data             = optional(map(string), {})
        disable          = optional(bool)
        plugin           = string
        validation_delay = optional(number)
      })), {})

      certificates = optional(map(object({
        manage    = optional(bool, true)
        account   = string
        force     = optional(bool)
        node_name = string

        domains = list(object({
          domain = string
          alias  = optional(string)
          plugin = optional(string)
        }))
      })), {})
    }), {})

    storages = optional(map(object({
      manage                  = optional(bool, true)
      type                    = string
      content                 = optional(set(string), [])
      disable                 = optional(bool)
      nodes                   = optional(set(string), [])
      shared                  = optional(bool)
      path                    = optional(string)
      preallocation           = optional(string)
      thin_pool               = optional(string)
      volume_group            = optional(string)
      zfs_pool                = optional(string)
      blocksize               = optional(string)
      thin_provision          = optional(bool)
      server                  = optional(string)
      export                  = optional(string)
      options                 = optional(string)
      share                   = optional(string)
      subdirectory            = optional(string)
      domain                  = optional(string)
      username                = optional(string)
      datastore               = optional(string)
      namespace               = optional(string)
      fingerprint             = optional(string)
      generate_encryption_key = optional(bool)
      observed                = optional(map(any), {})

      backups = optional(object({
        keep_all              = optional(bool)
        keep_daily            = optional(number)
        keep_hourly           = optional(number)
        keep_last             = optional(number)
        keep_monthly          = optional(number)
        keep_weekly           = optional(number)
        keep_yearly           = optional(number)
        max_protected_backups = optional(number)
      }))
    })), {})

    backup_jobs = optional(map(object({
      manage                    = optional(bool, true)
      all                       = optional(bool)
      bwlimit                   = optional(number)
      compress                  = optional(string)
      enabled                   = optional(bool)
      exclude_path              = optional(list(string), [])
      ionice                    = optional(number)
      lockwait                  = optional(number)
      mailnotification          = optional(string)
      mailto                    = optional(list(string), [])
      maxfiles                  = optional(number)
      mode                      = optional(string)
      node                      = optional(string)
      notes_template            = optional(string)
      pbs_change_detection_mode = optional(string)
      pigz                      = optional(number)
      pool                      = optional(string)
      protected                 = optional(bool)
      prune_backups             = optional(map(string))
      remove                    = optional(bool)
      repeat_missed             = optional(bool)
      schedule                  = string
      script                    = optional(string)
      starttime                 = optional(string)
      stdexcludes               = optional(bool)
      stopwait                  = optional(number)
      storage                   = string
      tmpdir                    = optional(string)
      vmid                      = optional(list(string), [])
      zstd                      = optional(number)

      fleecing = optional(object({
        enabled = optional(bool)
        storage = optional(string)
      }))

      performance = optional(object({
        max_workers     = optional(number)
        pbs_entries_max = optional(number)
      }))
    })), {})

    firewall = optional(object({
      manage         = optional(bool, false)
      ebtables       = optional(bool)
      enabled        = optional(bool)
      forward_policy = optional(string)
      input_policy   = optional(string)
      output_policy  = optional(string)

      log_ratelimit = optional(list(object({
        burst   = optional(number)
        enabled = optional(bool)
        rate    = optional(string)
      })), [])
    }), {})
  })

  nullable = false

  validation {
    condition     = length(trimspace(var.proxmox_cluster.endpoint.hostname)) > 0
    error_message = "proxmox_cluster.endpoint.hostname must not be empty."
  }

  validation {
    condition     = var.proxmox_cluster.endpoint.port >= 1 && var.proxmox_cluster.endpoint.port <= 65535
    error_message = "proxmox_cluster.endpoint.port must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for acl in var.proxmox_cluster.acls :
      length(compact([acl.user_id, acl.group_id, acl.token_id])) == 1
    ])
    error_message = "Each proxmox_cluster.acls entry must set exactly one of user_id, group_id, or token_id."
  }
}

#endregion --- [ Proxmox Cluster ] ---------------------------------------------------------- #

#region ------ [ Sensitive Inputs ] --------------------------------------------------------- #

variable "proxmox_cluster_secrets" {
  description = <<-EOT
    Sensitive Proxmox cluster inputs. Load this as one JSON object through
    TF_VAR_proxmox_cluster_secrets from a secret manager, not from committed
    tfvars. This keeps the operator-facing cluster file non-secret while still
    avoiding a sprawl of independent secret variables.
  EOT

  type = object({
    api_token = optional(object({
      id     = string
      secret = string
    }))

    user_passwords                 = optional(map(string), {})
    storage_passwords              = optional(map(string), {})
    storage_encryption_keys        = optional(map(string), {})
    acme_dns_plugin_sensitive_data = optional(map(map(string)), {})
  })

  default   = {}
  sensitive = true
  nullable  = false

  validation {
    condition     = try(var.proxmox_cluster_secrets.api_token.id, null) == null || can(regex("^[^@!]+@[^@!]+![^@!]+$", var.proxmox_cluster_secrets.api_token.id))
    error_message = "proxmox_cluster_secrets.api_token.id must use user@realm!token-name format."
  }

  validation {
    condition     = try(var.proxmox_cluster_secrets.api_token.secret, null) == null || length(trimspace(var.proxmox_cluster_secrets.api_token.secret)) > 0
    error_message = "proxmox_cluster_secrets.api_token.secret must not be empty."
  }

  validation {
    condition = alltrue(concat(
      [for _, value in var.proxmox_cluster_secrets.user_passwords : length(trimspace(value)) > 0],
      [for _, value in var.proxmox_cluster_secrets.storage_passwords : length(trimspace(value)) > 0],
      [for _, value in var.proxmox_cluster_secrets.storage_encryption_keys : length(trimspace(value)) > 0],
      flatten([
        for _, values in var.proxmox_cluster_secrets.acme_dns_plugin_sensitive_data : [
          for _, value in values : length(trimspace(value)) > 0
        ]
      ])
    ))
    error_message = "proxmox_cluster_secrets optional secret maps must not contain empty values."
  }
}

#endregion --- [ Sensitive Inputs ] --------------------------------------------------------- #
