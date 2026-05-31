# Runner Protocol

This Proxmox framework is a framework repository, not a data-only runner.

If a future runner consumes this framework, it must:

- pin this framework by a 40-character commit SHA,
- provide only runtime data and secret hydration,
- keep state outside the framework repository,
- run plans before applies, and
- avoid modifying framework implementation files through overlays.

Until a runner workflow exists, applies are an operator workflow and must be
documented in the consuming repository.
