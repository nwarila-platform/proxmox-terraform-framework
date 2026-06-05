package terraform_plan

test_bridge_without_comment_is_denied if {
	result := deny with input as {"resources": [{
		"address": "proxmox_virtual_environment_network_linux_bridge.bad",
		"type": "proxmox_virtual_environment_network_linux_bridge",
		"values": {"comment": ""},
	}]}
	"proxmox_virtual_environment_network_linux_bridge.bad must include a change-control comment before managed host networking is enabled" in result
}

test_vlan_with_comment_is_allowed if {
	result := deny with input as {"resources": [{
		"address": "proxmox_virtual_environment_network_linux_vlan.good",
		"type": "proxmox_virtual_environment_network_linux_vlan",
		"values": {"comment": "CAB-1234"},
	}]}
	count(result) == 0
}

test_empty_plan_is_denied if {
	result := deny with input as {"resources": []}
	"OPA plan gate must include at least one managed bridge or VLAN resource" in result
}
