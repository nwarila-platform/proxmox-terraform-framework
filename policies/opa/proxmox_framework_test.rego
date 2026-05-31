package proxmox_framework

test_network_bridge_without_comment_is_denied if {
  result := deny with input as {
    "resource_changes": [
      {
        "address": "proxmox_virtual_environment_network_linux_bridge.bridge[\"node/vmbr0\"]",
        "type": "proxmox_virtual_environment_network_linux_bridge",
        "change": {
          "after": {
            "comment": ""
          }
        }
      }
    ]
  }

  "proxmox_virtual_environment_network_linux_bridge.bridge[\"node/vmbr0\"] must include a change-control comment before managed host networking is enabled" in result
}

test_network_vlan_with_comment_is_allowed if {
  result := deny with input as {
    "resource_changes": [
      {
        "address": "proxmox_virtual_environment_network_linux_vlan.vlan[\"node/vlan10\"]",
        "type": "proxmox_virtual_environment_network_linux_vlan",
        "change": {
          "after": {
            "comment": "change CAB-1234"
          }
        }
      }
    ]
  }

  count(result) == 0
}
