# Threat Model

## In Scope

- Preventing secrets, state, plan files, and ignored tfvars from entering git.
- Keeping GitHub workflow execution pinned and centralized.
- Avoiding accidental live Proxmox changes during CI.
- Making risky host networking opt-in.
- Preserving a clear import-before-manage adoption path.

## Out Of Scope

- Protecting a live Proxmox cluster from a compromised operator workstation.
- Guaranteeing drift detection for a deployment that does not run scheduled
  plans against remote state.
- Hiding secrets once they are written into Terraform state by provider
  resources.
- Replacing Proxmox RBAC, network segmentation, backups, or host hardening.

## Primary Risks

- A broad Proxmox token can change cluster-wide settings.
- Saved plans and state can contain sensitive values.
- Incorrect networking declarations can disrupt host connectivity.
- Importing existing resources incorrectly can cause Terraform to recreate or
  replace live configuration.

## Controls

- Sensitive inputs are grouped under `proxmox_cluster_secrets`.
- `*.tfvars`, state, and plan files remain ignored by default.
- CI uses `terraform init -backend=false`.
- Repo-hygiene checks enforce SHA-pinned workflow references and exact
  Terraform/provider pins.
- Network resources default to `manage = false`.
