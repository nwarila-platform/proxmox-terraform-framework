param(
  [switch]$ContinueOnError,
  [switch]$Plan
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$terraformDir = Join-Path $repoRoot "terraform"
$envFile = Join-Path $repoRoot ".env"

function Set-SecretEnvironmentValue {
  param(
    [string]$Name,
    [string]$Value
  )

  if (-not [Environment]::GetEnvironmentVariable($Name, "Process")) {
    [Environment]::SetEnvironmentVariable($Name, $Value, "Process")
  }
}

if (Test-Path -LiteralPath $envFile) {
  foreach ($line in Get-Content -LiteralPath $envFile) {
    if ($line -notmatch '^\s*(?:export\s+)?([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.*)\s*$') {
      continue
    }

    $name = $Matches[1]
    $value = $Matches[2].Trim()

    if ($value.Length -ge 2) {
      $first = $value.Substring(0, 1)
      $last = $value.Substring($value.Length - 1, 1)
      if (($first -eq '"' -and $last -eq '"') -or ($first -eq "'" -and $last -eq "'")) {
        $value = $value.Substring(1, $value.Length - 2)
      }
    }

    switch -Regex ($name) {
      '^(username|PROXMOX_VE_USERNAME)$' {
        if ($value -notmatch '@(pam|pve)$') {
          $value = "${value}@pam"
        }

        Set-SecretEnvironmentValue -Name "PROXMOX_VE_USERNAME" -Value $value
        continue
      }
      '^(password|PROXMOX_VE_PASSWORD)$' {
        Set-SecretEnvironmentValue -Name "PROXMOX_VE_PASSWORD" -Value $value
        continue
      }
      '^(PROXMOX_API_TOKEN_ID)$' {
        Set-SecretEnvironmentValue -Name "PROXMOX_API_TOKEN_ID" -Value $value
        continue
      }
      '^(PROXMOX_API_TOKEN_SECRET)$' {
        Set-SecretEnvironmentValue -Name "PROXMOX_API_TOKEN_SECRET" -Value $value
        continue
      }
      '^(TF_VAR_proxmox_cluster_secrets)$' {
        Set-SecretEnvironmentValue -Name "TF_VAR_proxmox_cluster_secrets" -Value $value
        continue
      }
    }
  }
}

if (-not $env:TF_VAR_proxmox_cluster_secrets) {
  if ($env:PROXMOX_API_TOKEN_ID -and $env:PROXMOX_API_TOKEN_SECRET) {
    $secrets = @{
      api_token = @{
        id     = $env:PROXMOX_API_TOKEN_ID
        secret = $env:PROXMOX_API_TOKEN_SECRET
      }
      user_passwords                 = @{}
      storage_passwords              = @{}
      storage_encryption_keys        = @{}
      acme_dns_plugin_sensitive_data = @{}
    } | ConvertTo-Json -Depth 20 -Compress

    $env:TF_VAR_proxmox_cluster_secrets = $secrets
  }
  elseif (-not $env:PROXMOX_VE_USERNAME -or -not $env:PROXMOX_VE_PASSWORD) {
    throw "Set TF_VAR_proxmox_cluster_secrets, PROXMOX_API_TOKEN_ID/PROXMOX_API_TOKEN_SECRET, or username/password in .env before importing."
  }
}

$imports = @(
  @{
    Address = 'terraform_data.framework_validation'
    Id      = 'proxmox-cluster-framework-validation'
  }
  @{
    Address = 'proxmox_virtual_environment_cluster_options.this[0]'
    Id      = 'cluster'
  }
  @{
    Address = 'proxmox_virtual_environment_cluster_firewall.this[0]'
    Id      = 'cluster'
  }
  @{
    Address = 'proxmox_virtual_environment_dns.node["pve-node-01"]'
    Id      = 'pve-node-01'
  }
  @{
    Address = 'proxmox_virtual_environment_dns.node["pve-node-02"]'
    Id      = 'pve-node-02'
  }
  @{
    Address = 'proxmox_virtual_environment_dns.node["pve-node-03"]'
    Id      = 'pve-node-03'
  }
  @{
    Address = 'proxmox_virtual_environment_time.node["pve-node-01"]'
    Id      = 'pve-node-01'
  }
  @{
    Address = 'proxmox_virtual_environment_time.node["pve-node-02"]'
    Id      = 'pve-node-02'
  }
  @{
    Address = 'proxmox_virtual_environment_time.node["pve-node-03"]'
    Id      = 'pve-node-03'
  }
  @{
    Address = 'proxmox_virtual_environment_hosts.node["pve-node-01"]'
    Id      = 'pve-node-01'
  }
  @{
    Address = 'proxmox_virtual_environment_hosts.node["pve-node-02"]'
    Id      = 'pve-node-02'
  }
  @{
    Address = 'proxmox_virtual_environment_hosts.node["pve-node-03"]'
    Id      = 'pve-node-03'
  }
  @{
    Address = 'proxmox_virtual_environment_node_firewall.node["pve-node-01"]'
    Id      = 'pve-node-01'
  }
  @{
    Address = 'proxmox_virtual_environment_node_firewall.node["pve-node-02"]'
    Id      = 'pve-node-02'
  }
  @{
    Address = 'proxmox_virtual_environment_node_firewall.node["pve-node-03"]'
    Id      = 'pve-node-03'
  }
  @{
    Address = 'proxmox_virtual_environment_network_linux_bridge.bridge["pve-node-01/vmbr0"]'
    Id      = 'pve-node-01:vmbr0'
  }
  @{
    Address = 'proxmox_virtual_environment_network_linux_bridge.bridge["pve-node-02/vmbr0"]'
    Id      = 'pve-node-02:vmbr0'
  }
  @{
    Address = 'proxmox_virtual_environment_network_linux_bridge.bridge["pve-node-03/vmbr0"]'
    Id      = 'pve-node-03:vmbr0'
  }
  @{
    Address = 'proxmox_virtual_environment_network_linux_vlan.vlan["pve-node-01/vmbr0.100"]'
    Id      = 'pve-node-01:vmbr0.100'
  }
  @{
    Address = 'proxmox_virtual_environment_network_linux_vlan.vlan["pve-node-02/vmbr0.100"]'
    Id      = 'pve-node-02:vmbr0.100'
  }
  @{
    Address = 'proxmox_virtual_environment_network_linux_vlan.vlan["pve-node-03/vmbr0.100"]'
    Id      = 'pve-node-03:vmbr0.100'
  }
  @{
    Address = 'proxmox_virtual_environment_pool.pool["example-workload-pool"]'
    Id      = 'example-workload-pool'
  }
  @{
    Address = 'proxmox_virtual_environment_pool.pool["example-infra-pool"]'
    Id      = 'example-infra-pool'
  }
  @{
    Address = 'proxmox_virtual_environment_pool.pool["example-template-pool"]'
    Id      = 'example-template-pool'
  }
  @{
    Address = 'proxmox_virtual_environment_role.role["ExampleImageBuilder"]'
    Id      = 'ExampleImageBuilder'
  }
  @{
    Address = 'proxmox_virtual_environment_user.user["root@pam"]'
    Id      = 'root@pam'
  }
  @{
    Address = 'proxmox_virtual_environment_user.user["svc-runner@pve"]'
    Id      = 'svc-runner@pve'
  }
  @{
    Address = 'proxmox_virtual_environment_user_token.token["root_example_token_terraform"]'
    Id      = 'example-api-token-terraform'
  }
  @{
    Address = 'proxmox_virtual_environment_user_token.token["root_example_token_packer"]'
    Id      = 'example-api-token-packer'
  }
  @{
    Address = 'proxmox_virtual_environment_user_token.token["svc_runner"]'
    Id      = 'svc-runner@pve!svc-runner'
  }
  @{
    Address = 'proxmox_virtual_environment_acl.acl["/|Administrator|svc-runner@pve"]'
    Id      = '/?svc-runner@pve?Administrator'
  }
  @{
    Address = 'proxmox_virtual_environment_storage_directory.directory["local"]'
    Id      = 'local'
  }
  @{
    Address = 'proxmox_virtual_environment_storage_zfspool.zfspool["example-zfs"]'
    Id      = 'example-zfs'
  }
)

Push-Location $repoRoot
try {
  foreach ($item in $imports) {
    $address = $item.Address
    $terraformAddress = $address -replace '"', '\"'
    $id = $item.Id

    $previousErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
      & terraform -chdir="$terraformDir" state show -no-color $terraformAddress *> $null
      $alreadyImported = $LASTEXITCODE -eq 0
    }
    finally {
      $ErrorActionPreference = $previousErrorActionPreference
    }

    if ($alreadyImported) {
      Write-Host "SKIP  $address"
      continue
    }

    Write-Host "IMPORT $address <= $id"
    & terraform -chdir="$terraformDir" import -input=false -no-color $terraformAddress $id

    if ($LASTEXITCODE -ne 0) {
      $message = "Import failed for $address <= $id"
      if ($ContinueOnError) {
        Write-Warning $message
        continue
      }

      throw $message
    }
  }

  if ($Plan) {
    Write-Host "PLAN  terraform plan -input=false -no-color -detailed-exitcode"
    & terraform -chdir="$terraformDir" plan -input=false -no-color -detailed-exitcode

    if ($LASTEXITCODE -eq 0) {
      Write-Host "PLAN  no changes"
    }
    elseif ($LASTEXITCODE -eq 2) {
      Write-Warning "PLAN  changes detected"
    }
    else {
      throw "Plan failed with exit code $LASTEXITCODE"
    }
  }
}
finally {
  Pop-Location
}
