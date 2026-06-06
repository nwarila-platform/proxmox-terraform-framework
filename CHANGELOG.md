# Changelog

## [2.0.0](https://github.com/nwarila-platform/proxmox-terraform-framework/compare/v1.0.1...v2.0.0) (2026-06-06)


### ⚠ BREAKING CHANGES

* user_account removed from initialization block in tfvars. Inject credentials via TF_VAR_proxmox_cloud_init_user_name, TF_VAR_proxmox_cloud_init_user_password, and TF_VAR_proxmox_cloud_init_user_public_key environment variables.

### Features

* add .gitattributes for consistent line endings and language detection ([6f17ef7](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/6f17ef75ae06e01d5ec5b86bc37fd678b66f8910))
* add reusable IaC security scan caller ([#24](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/24)) ([cbf184a](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/cbf184a6f11f25639bc58ddc21b100cbce18a6ed))
* **ci:** adopt pr-validation (contract-and-lint mode) ([#33](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/33)) ([ed58636](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/ed58636038d873ef168b9f1dfe50d019c4160cac))
* **ci:** graduate to mode: full ([#41](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/41)) ([1015af7](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/1015af789c7db9db8a3ec4db7f15290ee9abd574))
* **ci:** lint_advisory + bump to 1c92039 + prep renovate.json5 ([#34](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/34)) ([f5bc037](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/f5bc037066963d57aa115332c15f2fe0701d7c78))
* complete contract scaffold + .gitignore allowlist ([#38](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/38)) ([029b0eb](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/029b0eb87735b8b1a8db24e44f0fa7f31e9a67f2))
* consume reusable CodeQL workflow ([#31](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/31)) ([df5a7db](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/df5a7db9a539e7953f3f37f9169b3e79bcc34165))
* contract scaffold + pin bump to ecb7a74 ([#28](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/28)) ([512e69f](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/512e69f3965132556c63c579eaa02da64bea8e34))
* enhance network device configuration with optional IPv4 prefix length ([988a591](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/988a591001b9c27032caff23c26985c96e278453))
* implement dynamic initialization properties for virtual machines ([48f1ea7](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/48f1ea7c0410d5524b1be50f24c3a7fa3f706d34))
* move cloud-init credentials to top-level sensitive variables ([49c05bf](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/49c05bfe00b1ab0af04acc72923c8fb7ffbf6592))
* onboard NWarila/terraform-template@aeb3d18 (sync only) ([#18](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/18)) ([706f2ff](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/706f2ff12023c9543d06c5e2b32cadbfbad7bb4b))
* **security:** adopt OpenSSF Scorecard + bump pin to 9d354ff ([#45](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/45)) ([c07ac84](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/c07ac847dca4442f0936b25fb29df10feb693f37))
* **terraform:** allow persisted disks to attach on separate interface ([9c8457c](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/9c8457c6a67ecaddfd7653467767ad96b8e5f4de))
* **terraform:** expose stable VM disk interfaces ([0f9b8d3](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/0f9b8d36b6480a6cfa05d12bf823bfeb8e5cdffd))
* **terraform:** generate ansible inventory outputs ([6bac600](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/6bac60087cc2a95ff8d9e37387f2b5dd672dbb4c))
* **terraform:** preserve persistent VM disks ([2e9644c](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/2e9644cadd03f0ff512b3941fe4eb7f595c6e728))


### Bug Fixes

* align proxmox terraform docs nav ([#58](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/58)) ([08b573b](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/08b573b33b9aa793258cee40c04178d23ac88392))
* **ci:** drop forbidden *_advisory inputs on security caller ([#48](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/48)) ([050417b](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/050417bf4860bebb7ca1b5bd483c72e5a39eef3e))
* **contract:** exact tf pins + SHA-pin actions + PR template casing ([#39](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/39)) ([6c229bd](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/6c229bd63ffdf823fd278ec5b9e1d78680d3a0f5))
* **contract:** SHA-pin release-please-action ([#40](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/40)) ([2949d35](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/2949d35f2d169e8b013fb91850e005d9af37a0b9))
* repair proxmox terraform main workflows ([#57](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/57)) ([3b75d2e](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/3b75d2eb334053773cc5fa3a6bd2d6b1a4b7325f))
* restore proxmox terraform CI ([#56](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/56)) ([181e826](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/181e826d396416f3640fdaf47a86f08972469b49))
* **terraform:** tolerate unused missing templates ([e9d589d](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/e9d589dc5ba952b0dc6125756317bf93c80aa806))

## [1.0.1](https://github.com/NWarila/proxmox-terraform-framework/compare/v1.0.0...v1.0.1) (2026-03-09)


### Bug Fixes

* secure TLS default and document proxmox_skip_tls_verify ([fe7cc5f](https://github.com/NWarila/proxmox-terraform-framework/commit/fe7cc5fef13f91df0f2936227014a823224910e8))

## 1.0.0 (2026-03-09)


### Bug Fixes

* correct pip cache path and release-please action ref ([5f2cb69](https://github.com/NWarila/proxmox-terraform-framework/commit/5f2cb697f8d0cb9162c13e5fdc232c3a8bb8d9fa))
