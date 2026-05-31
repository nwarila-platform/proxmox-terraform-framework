# Develop This Module

## Tooling

Install the same tool versions used by CI:

- Terraform 1.15.2
- TFLint 0.62.0
- terraform-docs 0.23.0
- OPA 1.10.0
- Python 3.12

CI installs these through `tools/install_ci_tools.sh` on Linux runners. On
Windows, install native binaries or use a Linux shell/container.

## Development Loop

```sh
make fmt
make ci
make docs
```

Run `terraform -chdir=terraform validate` after schema or provider changes.
Run `make docs` whenever Terraform inputs, outputs, or resources change.

## Before Opening A PR

```sh
make ci
```

If a tool is unavailable locally, call that out in the PR test plan and rely on
the GitHub workflow result for that gate.
