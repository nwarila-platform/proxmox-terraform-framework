# Changelog

## [2.0.0](https://github.com/nwarila-platform/proxmox-terraform-framework/compare/v1.0.1...v2.0.0) (2026-06-05)


### ⚠ BREAKING CHANGES

* user_account removed from initialization block in tfvars. Inject credentials via TF_VAR_proxmox_cloud_init_user_name, TF_VAR_proxmox_cloud_init_user_password, and TF_VAR_proxmox_cloud_init_user_public_key environment variables.

### Features

* add .gitattributes for consistent line endings and language detection ([af97cc6](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/af97cc6aabd4f73d6ac4bf82f8eaae66589810ea))
* add reusable IaC security scan caller ([#24](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/24)) ([500bc93](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/500bc93e54a3482a50e6ec53c875d7bc2bcd2a10))
* **ci:** adopt pr-validation (contract-and-lint mode) ([#33](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/33)) ([9ea2447](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/9ea2447d025ce88494b56e89bc4ef04e6d469fad))
* **ci:** graduate to mode: full ([#41](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/41)) ([cf0ebed](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/cf0ebed3472763b165783fbdaa152eb801d0d0e5))
* **ci:** lint_advisory + bump to 1c92039 + prep renovate.json5 ([#34](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/34)) ([69974d3](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/69974d316b727a3ad7363178cf657d22f523788f))
* complete contract scaffold + .gitignore allowlist ([#38](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/38)) ([3306b5c](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/3306b5c256bdc44dbacdb3834034be509bfb24cc))
* consume reusable CodeQL workflow ([#31](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/31)) ([3033b5a](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/3033b5a8d705ee5ceee03edcbb63db243face33e))
* contract scaffold + pin bump to ecb7a74 ([#28](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/28)) ([4a79225](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/4a792258a742dc08c4671fdb8d0a25f18fb19721))
* enhance network device configuration with optional IPv4 prefix length ([5a2fbe6](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/5a2fbe6b306449ef934a0493fb2967dc619f804e))
* implement dynamic initialization properties for virtual machines ([b9d7ec7](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/b9d7ec7cdf6c71769efbbdff7655d66dceea53dd))
* move cloud-init credentials to top-level sensitive variables ([f05e217](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/f05e217475cd5c62c4d0b8eff3594d6f5064bbaa))
* onboard NWarila/terraform-template@aeb3d18 (sync only) ([#18](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/18)) ([1b2b6fb](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/1b2b6fb02d8e749a45eb952a7814800cff3aa60f))
* **security:** adopt OpenSSF Scorecard + bump pin to 9d354ff ([#45](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/45)) ([c9ba0da](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/c9ba0daa19704359459b9a2baa53b346bd272147))
* **terraform:** allow persisted disks to attach on separate interface ([1609e60](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/1609e602d52a7d7465bfbebabdcedeaad216d5e7))
* **terraform:** expose stable VM disk interfaces ([5e61ac4](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/5e61ac43ca382ad85ac2cfbcb7b0c9359eebce6e))
* **terraform:** generate ansible inventory outputs ([09ea4a9](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/09ea4a969b67d438d4ee03fd7a480524fc27e2d4))
* **terraform:** preserve persistent VM disks ([c9766c1](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/c9766c1835ef91133558e822ba98c0cd5561ef8b))


### Bug Fixes

* align proxmox terraform docs nav ([#58](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/58)) ([76f28aa](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/76f28aa3e23a6b2c21f067cd0ed362de28738984))
* **ci:** drop forbidden *_advisory inputs on security caller ([#48](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/48)) ([d9a4756](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/d9a4756ad21ace3287a26cd834c8265869fad4f5))
* **contract:** exact tf pins + SHA-pin actions + PR template casing ([#39](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/39)) ([dfcb6c0](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/dfcb6c07aa44c3eeb42743590fdad3632e88fe27))
* **contract:** SHA-pin release-please-action ([#40](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/40)) ([b5e1ee1](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/b5e1ee1836f06d642f116a51cfef17024dcb49fb))
* repair proxmox terraform main workflows ([#57](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/57)) ([56865ca](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/56865ca5cc602b2d6bc43c322af379753a3eef06))
* restore proxmox terraform CI ([#56](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/56)) ([07026c4](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/07026c4ee504a4a8dfc38df663f812120beb8270))
* **terraform:** tolerate unused missing templates ([4cbe15b](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/4cbe15b72904ccfe61140d16ba6c3f42f35a7f16))

## [1.0.1](https://github.com/NWarila/proxmox-terraform-framework/compare/v1.0.0...v1.0.1) (2026-03-09)


### Bug Fixes

* secure TLS default and document proxmox_skip_tls_verify ([fe7cc5f](https://github.com/NWarila/proxmox-terraform-framework/commit/fe7cc5fef13f91df0f2936227014a823224910e8))

## 1.0.0 (2026-03-09)


### Bug Fixes

* correct pip cache path and release-please action ref ([5f2cb69](https://github.com/NWarila/proxmox-terraform-framework/commit/5f2cb697f8d0cb9162c13e5fdc232c3a8bb8d9fa))
