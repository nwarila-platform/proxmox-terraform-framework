# Getting Started

## Prerequisites

| Tool | Version |
| --- | --- |
| Terraform | `= 1.15.2` |
| TFLint | `= 0.62.0` |
| terraform-docs | `= 0.23.0` |
| OPA | `= 1.10.0` |

## Clone

```sh
git clone git@github.com:nwarila-platform/proxmox-terraform-framework.git
cd proxmox-terraform-framework
```

## Provide Secrets

Keep secrets out of tracked files. For API-token authentication, hydrate the
sensitive object from a secret manager, shell environment, or CI secret store:

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

For a local adoption import, username/password provider environment variables
are also supported:

```powershell
$env:PROXMOX_VE_USERNAME = "root@pam"
$env:PROXMOX_VE_PASSWORD = "<password>"
```

Use API tokens for routine automation once the cluster is adopted.

## Validate Locally

```sh
terraform -chdir=terraform init -backend=false -input=false
terraform -chdir=terraform validate
```

Use `make ci` for the full local gate set when all tools are available.

## Plan Safely

Before applying against an existing cluster:

1. Configure a remote backend with locking.
2. Populate an ignored tfvars file for the non-secret cluster declaration.
3. Import existing resources before setting matching declarations to
   `manage = true`.
4. Review the plan for host networking, storage, and RBAC changes.
