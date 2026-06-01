# Mirroring And Template Alignment

This repo follows the Terraform framework-template model.

## byte_identical

`baseline-manifest.json` lists files that should remain byte-identical to the
template contract. These are limited to shared contract files whose drift would
make this framework stop behaving like a framework-template consumer.

## scaffold_starter

Starter files are seeded from the template but may diverge for the Proxmox
domain. Examples include `.gitignore`, `Makefile`, the PR template, Renovate
configuration, and repo-specific quality-gate documentation.

## Template-Only

Universal reusable workflows live in `nwarila-platform/.github`. Terraform-template
release/deploy reusables live in `NWarila/terraform-framework-template`. This
repo calls those by SHA when needed instead of copying them locally.
