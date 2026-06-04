package terraform_plan

import rego.v1

deny contains msg if {
	resource := input.resources[_]
	resource.type == "proxmox_virtual_environment_network_linux_bridge"
	not has_nonempty(object.get(resource.values, "comment", ""))
	msg := sprintf("%s must include a change-control comment before managed host networking is enabled", [resource.address])
}

deny contains msg if {
	resource := input.resources[_]
	resource.type == "proxmox_virtual_environment_network_linux_vlan"
	not has_nonempty(object.get(resource.values, "comment", ""))
	msg := sprintf("%s must include a change-control comment before managed host networking is enabled", [resource.address])
}

has_nonempty(value) if {
	is_string(value)
	trim(value, " ") != ""
}
