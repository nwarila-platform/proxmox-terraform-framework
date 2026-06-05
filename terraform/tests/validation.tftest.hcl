# Validation-only tests. These runs intentionally use inputs that fail variable
# validation before Terraform can plan live Proxmox resources.

mock_provider "proxmox" {}

run "plan_managed_bridge_with_change_comment" {
  command = plan

  variables {
    proxmox_cluster = {
      endpoint = {
        hostname = "proxmox.example.invalid"
      }

      options = {
        manage = false
      }

      nodes = {
        pve01 = {
          networks = {
            vmbr100 = {
              manage     = true
              type       = "linux_bridge"
              comment    = "CAB-1234: CI OPA plan fixture"
              ports      = ["eno1"]
              vlan_aware = true
            }
          }
        }
      }
    }

    proxmox_cluster_secrets = {
      api_token = {
        id     = "terraform@pve!ci"
        secret = "not-a-real-token"
      }
    }
  }
}

run "reject_empty_endpoint_hostname" {
  command = plan

  variables {
    proxmox_cluster = {
      endpoint = {
        hostname = ""
      }
    }

    proxmox_cluster_secrets = {
      api_token = {
        id     = "terraform@pve!ci"
        secret = "not-a-real-token"
      }
    }
  }

  expect_failures = [
    var.proxmox_cluster,
  ]
}

run "reject_out_of_range_endpoint_port" {
  command = plan

  variables {
    proxmox_cluster = {
      endpoint = {
        hostname = "proxmox.example.invalid"
        port     = 70000
      }
    }

    proxmox_cluster_secrets = {
      api_token = {
        id     = "terraform@pve!ci"
        secret = "not-a-real-token"
      }
    }
  }

  expect_failures = [
    var.proxmox_cluster,
  ]
}

run "reject_acl_with_multiple_principals" {
  command = plan

  variables {
    proxmox_cluster = {
      endpoint = {
        hostname = "proxmox.example.invalid"
      }

      acls = [
        {
          path     = "/"
          role_id  = "PVEAuditor"
          user_id  = "terraform@pve"
          group_id = "admins"
        }
      ]
    }

    proxmox_cluster_secrets = {
      api_token = {
        id     = "terraform@pve!ci"
        secret = "not-a-real-token"
      }
    }
  }

  expect_failures = [
    var.proxmox_cluster,
  ]
}

run "reject_invalid_api_token_id" {
  command = plan

  variables {
    proxmox_cluster = {
      endpoint = {
        hostname = "proxmox.example.invalid"
      }
    }

    proxmox_cluster_secrets = {
      api_token = {
        id     = "terraform@pve"
        secret = "not-a-real-token"
      }
    }
  }

  expect_failures = [
    var.proxmox_cluster_secrets,
  ]
}
