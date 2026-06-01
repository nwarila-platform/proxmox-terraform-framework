# Architecture Decision Records

This directory contains the Architecture Decision Records (ADRs) for this
repository.

ADRs are organized into two scopes per
[org ADR-0001](https://github.com/nwarila-platform/.github/blob/main/docs/decision-records/0001-use-architecture-decision-records.md):

- `org/` - byte-identical mirrors of org-baseline ADRs from `nwarila-platform/.github`.
- `repo/` - repository-specific ADRs.

## Org ADRs

The `org/` scope is mirrored from `nwarila-platform/.github`.

| ADR | Status | Decision |
| --- | --- | --- |
| [ADR-0001](org/0001-use-architecture-decision-records.md) | Accepted | Use Architecture Decision Records. |
| [ADR-0002](org/0002-adopt-diataxis-documentation-framework.md) | Accepted | Use Diataxis for non-ADR documentation. |
| [ADR-0003](org/0003-use-deny-all-gitignore-strategy.md) | Accepted | Use deny-all `.gitignore` allowlists. |
| [ADR-0004](org/0004-use-renovate-for-dependency-updates.md) | Accepted | Use Renovate for dependency updates. |
| [ADR-0005](org/0005-keep-github-control-planes-namespace-local.md) | Accepted | Keep GitHub control planes namespace-local. |

The `.gitkeep` placeholder in `repo/` keeps the directory skeleton complete
until this repository has a repo-specific ADR.
