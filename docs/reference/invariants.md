# Invariants

- Terraform CLI and provider versions are exact pins.
- Universal GitHub Actions controls are called from `nwarila-platform/.github` by
  40-character commit SHA.
- This repo does not vendor universal reusable workflows.
- Secrets are supplied through sensitive variables or CI/secrets-manager
  hydration, never tracked tfvars.
- Local and CI validation use `terraform init -backend=false`.
- Real applies require remote state with locking and an operator-reviewed plan.
- Existing Proxmox resources are imported before corresponding declarations set
  `manage = true`.
- Host networking remains opt-in and defaults to `manage = false`.
- Generated Terraform docs must match the current `terraform/` directory.
