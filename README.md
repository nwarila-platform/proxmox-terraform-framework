# proxmox-terraform-framework

Terraform framework for managing the Proxmox VE cluster layer: datacenter
options, node DNS/time/host metadata, pools, roles, users, ACLs, ACME
certificate automation, storage definitions, backup jobs, and carefully gated
node networking.

Guest workloads live in
[`proxmox-vm-terraform-framework`](https://github.com/nwarila-platform/proxmox-vm-terraform-framework).
This repository is for the Proxmox host and cluster control plane.

## Design Contract

- A single simple `.tfvars` file should describe the cluster.
- Secrets stay out of tracked files and are supplied through `TF_VAR_*` values
  or ignored local tfvars files.
- Variable files use plain HCL literals only, matching the same discipline used
  by the Packer-facing repos.
- Existing live resources should be imported before `manage = true` resources
  are applied.
- Provider-unsupported state is still captured in variables and exposed through
  outputs, but not forced through a resource.
- Risky host networking is captured with `manage = false` by default.

## Current Local State

The live Proxmox cluster was inventoried into:

```text
terraform/current-state.auto.tfvars
```

That file is intentionally ignored by git. It can capture the current cluster,
pool, role, ACL, storage, certificate, and ACME plugin state without exposing
environment-specific values in tracked examples.

## Secrets

API-token secrets are supplied as one sensitive Terraform variable:

```text
TF_VAR_proxmox_cluster_secrets
```

That keeps the cluster inventory in one simple HCL file while avoiding a sprawl
of secret variables. Build the JSON from a local secret manager or CI secret
store instead of committing it:

```powershell
$secrets = @{
  api_token = @{
    id     = $env:PROXMOX_API_TOKEN_ID
    secret = $env:PROXMOX_API_TOKEN_SECRET
  }
  user_passwords = @{}
  storage_passwords = @{}
  storage_encryption_keys = @{}
  acme_dns_plugin_sensitive_data = @{}
} | ConvertTo-Json -Depth 20 -Compress

$env:TF_VAR_proxmox_cluster_secrets = $secrets
```

The object supports:

- `api_token`: provider token in `user@realm!token` format plus secret value.
- `user_passwords`: keyed by Proxmox user id, for managed user resources.
- `storage_passwords`: keyed by storage id, for CIFS or PBS storage.
- `storage_encryption_keys`: keyed by storage id, for PBS encryption keys.
- `acme_dns_plugin_sensitive_data`: keyed by DNS plugin id, for provider tokens.

The provider can also authenticate with username/password environment values,
which is useful for one-off local adoption imports:

```powershell
$env:PROXMOX_VE_USERNAME = "root@pam"
$env:PROXMOX_VE_PASSWORD = "<password>"
```

Prefer API tokens for routine automation because they are scoped and revocable.

Good local sources are PowerShell SecretManagement, Windows Credential Manager,
1Password CLI, or a private ignored `.env` that only hydrates the environment.
Do not commit secret `*.tfvars` files or saved plan files.

Terraform marks `proxmox_cluster_secrets` as sensitive, which protects normal
CLI output, but state and saved plan files still need the same protection as
the secrets themselves. Keep state encrypted, access-controlled, and outside
public repos. Prefer short-lived or narrowly scoped Proxmox tokens where the
workflow allows it.

## Workflow

```bash
cd terraform
terraform init -backend=false
terraform validate
terraform plan
```

For the existing cluster, import current resources before applying managed
objects. The first safe apply target is usually ACME certificate automation once
the ACME account and validation method are declared.
