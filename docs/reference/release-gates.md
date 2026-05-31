# Release Gates

PRs to `main` are expected to pass:

- `PR Validation / make ci`
- `Repo Hygiene / repo-hygiene / verify`
- `Security Scan / IaC and secret scan`
- `CodeQL Analysis / CodeQL`

OpenSSF Scorecard runs on push, branch-protection, schedule, and manual paths.
Release automation runs through `release.yaml`; push-triggered release-please is
enabled only when the repository variable `RELEASE_PLEASE_ON_PUSH` is set to
`true`.

`make ci` currently includes Terraform fmt/init/validate/test, TFLint,
terraform-docs drift, docs layout, and OPA tests. If any local gate is deferred
or unavailable, the PR must say so explicitly in its test plan.
