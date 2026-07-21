tflint {
  required_version = "= 0.62.0"
}

config {
  call_module_type     = "all"
  force                = false
  disabled_by_default = false
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

rule "terraform_standard_module_structure" {
  enabled = false
}
