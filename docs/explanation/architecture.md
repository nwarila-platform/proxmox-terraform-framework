# Architecture

This repository is a Terraform framework for the Proxmox VE cluster control
plane. It manages cluster and host-level configuration: datacenter options,
node DNS/time/hosts metadata, pools, roles, users, ACLs, ACME automation,
storage declarations, backup jobs, and gated host networking.

Guest VM workloads are intentionally out of scope and belong in the VM
framework repository.

## Framework Shape

The Terraform implementation follows the framework-template layout:

| File | Role |
| --- | --- |
| `terraform/versions.tf` | Exact Terraform and provider pins. |
| `terraform/providers.tf` | Provider configuration from variables only. |
| `terraform/backend.tf` | Backend scaffold; production applies need remote state. |
| `terraform/data.tf` | Provider data sources. |
| `terraform/variables.tf` | Consumer-facing Proxmox cluster contract. |
| `terraform/locals.tf` | Selection, flattening, and validation helpers. |
| `terraform/main.tf` | Resource instantiation. |
| `terraform/outputs.tf` | Summary and adoption outputs. |

## Automation Topology

Universal controls are called from `nwarila-platform/.github` by SHA. This repo does not
vendor those reusable workflows.

| Workflow | Purpose |
| --- | --- |
| `pr-validation.yaml` | Installs pinned tools and runs `make ci`. |
| `security.yaml` | Calls the org IaC/security reusable. |
| `codeql.yaml` | Calls the org CodeQL reusable. |
| `scorecard.yaml` | Calls the org OpenSSF Scorecard reusable. |
| `repo-hygiene.yaml` | Calls the org repo-hygiene policy reusable. |
| `release.yaml` | Runs release-please and release evidence when enabled. |

## State And Apply Boundary

CI initializes Terraform with `-backend=false` and must not talk to a live
Proxmox cluster. Real applies need:

- a remote backend with encryption and locking,
- Proxmox credentials supplied outside tracked files,
- imports for existing live resources before setting `manage = true`, and
- an operator-reviewed plan.

## Adoption Model

The framework supports gradual adoption. Existing resources can be represented
in ignored tfvars first, then imported and moved under management resource by
resource. Risky host networking defaults to `manage = false`.
