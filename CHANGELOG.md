# Changelog

## [2.0.0](https://github.com/nwarila-platform/proxmox-terraform-framework/compare/v1.0.1...v2.0.0) (2026-05-07)


### ⚠ BREAKING CHANGES

* user_account removed from initialization block in tfvars. Inject credentials via TF_VAR_proxmox_cloud_init_user_name, TF_VAR_proxmox_cloud_init_user_password, and TF_VAR_proxmox_cloud_init_user_public_key environment variables.

### Features

* add .gitattributes for consistent line endings and language detection ([ae8f7b1](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/ae8f7b141d5b0f4f90e2e4b7e05d23328272c0ce))
* enhance network device configuration with optional IPv4 prefix length ([d3d1c3f](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/d3d1c3f59c5761f7a79a61dcf924e51a22542775))
* implement dynamic initialization properties for virtual machines ([43cb0d3](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/43cb0d3fa08bc3be6fac6c613501ca3046926e79))
* move cloud-init credentials to top-level sensitive variables ([4ee7dc8](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/4ee7dc8c1edcaf744f82b20fa638a7129b5ee8cb))
* onboard NWarila/terraform-template@aeb3d18 (sync only) ([#18](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/18)) ([1d7d731](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/1d7d731b7309a08189e840096a4c1b5db6aced42))

## [1.0.1](https://github.com/NWarila/proxmox-terraform-framework/compare/v1.0.0...v1.0.1) (2026-03-09)


### Bug Fixes

* secure TLS default and document proxmox_skip_tls_verify ([fe7cc5f](https://github.com/NWarila/proxmox-terraform-framework/commit/fe7cc5fef13f91df0f2936227014a823224910e8))

## 1.0.0 (2026-03-09)


### Bug Fixes

* correct pip cache path and release-please action ref ([5f2cb69](https://github.com/NWarila/proxmox-terraform-framework/commit/5f2cb697f8d0cb9162c13e5fdc232c3a8bb8d9fa))
