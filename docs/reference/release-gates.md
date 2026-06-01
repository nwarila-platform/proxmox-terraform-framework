# Release Gates

PRs to `main` must pass:

- `CI` (`make ci`: Terraform fmt/init/validate/test, TFLint,
  terraform-docs diff, Diataxis docs layout, and OPA policy tests)
- `Security` (delegates to the platform CodeQL, IaC/security, and Scorecard reusables)
- `Template Sync` (`NWarila/drift-gate` against
  `NWarila/terraform-framework-template@072ae1cbc288fdcc9b02ecb75e71d18794a07d27`)
- `Repo Hygiene` (`nwarila-platform/.github` repo-hygiene policy)

Workflow and action references are 40-character SHA-pinned per the repo-hygiene
contract.
