package proxmox_framework

deny contains msg if {
  some resource in input.resource_changes
  resource.type == "proxmox_virtual_environment_network_linux_bridge"
  after := resource.change.after
  not has_nonempty(after.comment)
  msg := sprintf("%s must include a change-control comment before managed host networking is enabled", [resource.address])
}

deny contains msg if {
  some resource in input.resource_changes
  resource.type == "proxmox_virtual_environment_network_linux_vlan"
  after := resource.change.after
  not has_nonempty(after.comment)
  msg := sprintf("%s must include a change-control comment before managed host networking is enabled", [resource.address])
}

has_nonempty(value) if {
  is_string(value)
  trim(value, " ") != ""
}
