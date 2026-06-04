param(
  [switch]$ContinueOnError,
  [switch]$Plan,
  [string]$ImportsPath,
  [switch]$WriteExampleImports
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$terraformDir = Join-Path $repoRoot "terraform"
$envFile = Join-Path $repoRoot ".env"
$exampleImportsPath = Join-Path $PSScriptRoot "import_current_state.imports.example.json"

if (-not $ImportsPath) {
  $ImportsPath = Join-Path $PSScriptRoot "import_current_state.imports.local.json"
}

function Set-SecretEnvironmentValue {
  param(
    [string]$Name,
    [string]$Value
  )

  if (-not [Environment]::GetEnvironmentVariable($Name, "Process")) {
    [Environment]::SetEnvironmentVariable($Name, $Value, "Process")
  }
}

if ($WriteExampleImports) {
  if (Test-Path -LiteralPath $ImportsPath) {
    throw "Refusing to overwrite existing import map '$ImportsPath'."
  }

  Copy-Item -LiteralPath $exampleImportsPath -Destination $ImportsPath
  Write-Host "WROTE $ImportsPath"
  return
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

function Read-ImportMap {
  param(
    [string]$Path
  )

  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Create a local import map at '$Path' before importing. Use '$exampleImportsPath' as the placeholder example; the local import map is intentionally gitignored."
  }

  $document = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
  $rawImports = $document
  if ($document.PSObject.Properties.Name -contains "imports") {
    $rawImports = $document.imports
  }

  $imports = @()
  foreach ($item in @($rawImports)) {
    if (-not $item.Address -or -not $item.Id) {
      throw "Every import map entry in '$Path' must contain Address and Id fields."
    }

    $imports += [pscustomobject]@{
      Address = [string]$item.Address
      Id      = [string]$item.Id
    }
  }

  if ($imports.Count -eq 0) {
    throw "Import map '$Path' did not contain any imports."
  }

  return $imports
}

$imports = Read-ImportMap -Path $ImportsPath

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
