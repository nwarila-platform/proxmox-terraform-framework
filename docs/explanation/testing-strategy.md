# Testing Strategy

## Local Gates

`make ci` is the repo-owned validation surface. It runs:

- `terraform fmt -check`
- `terraform init -backend=false`
- `terraform validate`
- `terraform test`
- `tflint`
- `terraform-docs --output-check`
- `tools/check_docs_layout.py`
- `opa test policies/opa`

## What These Gates Prove

- Terraform syntax and type checks pass without live backend credentials.
- Generated docs match the current Terraform interface.
- Documentation files stay in the expected Diataxis layout.
- Policy files parse and their tests pass when policies exist.

## What They Do Not Prove

- A real Proxmox apply is safe.
- Existing live resources have been imported correctly.
- Remote state, drift detection, and credentials are configured.
- Provider-backed `terraform test` cases are non-mutating unless the test file
  is reviewed for that property.

Live apply confidence must come from a reviewed plan against remote state in the
deployment environment.
