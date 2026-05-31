# State backend.
#
# Local validation uses `terraform init -backend=false`, so this empty block
# keeps the framework initialization path explicit without requiring live state
# credentials. Real Proxmox deployments should replace this with a remote
# backend that provides encryption, access control, and locking.

terraform {
  # Local backend is Terraform's default. Production callers should replace
  # this with an S3, GCS, azurerm, or HCP Terraform backend before apply.
}
