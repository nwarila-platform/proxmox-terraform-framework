package terraform_plan

import rego.v1

guarded_resource_types := {
	"proxmox_virtual_environment_network_linux_bridge",
	"proxmox_virtual_environment_network_linux_vlan",
}

guarded_resources contains resource if {
	resource := input.resources[_]
	guarded_resource_types[resource.type]
}

deny contains msg if {
	count(guarded_resources) == 0
	msg := "OPA plan gate must include at least one managed bridge or VLAN resource"
}

deny contains msg if {
	resource := guarded_resources[_]
	not has_nonempty(object.get(resource.values, "comment", ""))
	msg := sprintf("%s must include a change-control comment before managed host networking is enabled", [resource.address])
}

has_nonempty(value) if {
	is_string(value)
	trim(value, " ") != ""
}
