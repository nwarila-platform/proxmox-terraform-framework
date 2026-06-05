# Quality Gates

| Gate | Source | Role |
| --- | --- | --- |
| Terraform fmt/init/validate/test | `make ci` via `pr-validation.yaml` | Blocking |
| TFLint | `make ci` via `pr-validation.yaml` | Blocking |
| terraform-docs drift | `make ci` via `pr-validation.yaml` | Blocking |
| Docs layout | `make ci` via `pr-validation.yaml` | Blocking |
| OPA tests | `make ci` via `pr-validation.yaml` | Blocking |
| OPA plan gate | `make ci` via `pr-validation.yaml` | Blocking |
| Repo hygiene | `repo-hygiene.yaml` | Blocking |
| IaC/security scan | `security.yaml` | Blocking |
| GitHub Actions CodeQL | `codeql.yaml` | Blocking for workflow/static-analysis coverage; HCL coverage comes from Terraform, TFLint, OPA, and Trivy |
| OpenSSF Scorecard | `scorecard.yaml` | Scheduled/push posture |
| Release evidence | `release.yaml` | Release |

Local verification should use `make ci` for the repo-owned gates. GitHub-hosted
workflows provide the strongest evidence for org reusable callers.
