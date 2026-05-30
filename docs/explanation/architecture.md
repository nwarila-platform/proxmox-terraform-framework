# Architecture

## Overview

This framework is the Proxmox Terraform layer for VM definitions. It keeps the
Terraform module, validation toolchain, documentation generation, and GitHub
Actions controls in the same repository so changes to infrastructure behavior
and changes to quality gates can be reviewed together.

## GitOps Flow

```mermaid
flowchart TD
    Dev["Developer workstation\nVS Code + devcontainer\nTerraform, TFLint, Trivy, terraform-docs, pre-commit"]
    Hooks["Pre-commit hooks\ngitleaks, trivy, terraform fmt/validate,\ntflint, markdownlint, yamllint,\nconventional commits"]
    PR["Pull request"]
    CI["CI workflow\nmake ci"]
    Security["Security workflow\nTrivy/Gitleaks, CodeQL, Scorecard"]
    Drift["Template Sync + Repo Hygiene\nbaseline drift and workflow policy"]
    Pages["Deploy Docs\nterraform-docs, Trivy report, MkDocs"]
    Release["Release Please\nchangelog, release PR, tags"]

    Dev --> Hooks --> PR
    PR --> CI
    PR --> Security
    PR --> Drift
    CI --> Pages
    PR --> Release
```

## Framework Consumption Pattern

This repo is a framework: it defines provider configuration, reusable module
shape, and validation rules. Downstream repos consume it to deploy actual
infrastructure and own state, credentials, backend configuration, and
environment-specific `tfvars`.

```mermaid
flowchart LR
    Framework["This repository\nproviders, variables, resources,\nquality gates"]
    Consumer["Downstream infra repo\ntfvars, backend, credentials,\nplan/apply schedule"]
    Proxmox["Proxmox VE\nVMs, storage pools, networks"]

    Framework --> Consumer --> Proxmox
```

## Security Control Layers

| Layer | Controls |
| --- | --- |
| Local | pre-commit hooks for secret scanning, formatting, Terraform validation, linting, and commit message format |
| PR and push CI | `CI`, `Security`, `Template Sync`, and `Repo Hygiene` workflows |
| Continuous | Scheduled security and repo-hygiene runs plus Dependabot dependency PRs |
| Supply chain | SHA-pinned Actions, `persist-credentials: false`, exact Terraform/provider pins |

## Repository Structure

```text
proxmox-terraform-framework/
|-- .config/                    # Tool configuration
|-- .devcontainer/              # Reproducible development environment
|-- .github/
|   |-- actions/                # Local Terraform composite actions
|   `-- workflows/
|       |-- ci.yaml
|       |-- security.yaml
|       |-- template-sync.yaml
|       |-- repo-hygiene.yaml
|       |-- pages.yaml
|       |-- release-please.yaml
|       `-- terraform.yaml
|-- .vscode/                    # Workspace settings and tasks
|-- docs/                       # MkDocs source
|-- examples/                   # Usage examples
|-- requirements/               # Pinned Python dependencies
|-- terraform/                  # Core Terraform configuration
|-- .pre-commit-config.yaml
|-- release-please-config.json
`-- .release-please-manifest.json
```
