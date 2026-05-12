# Changelog

## [2.0.0](https://github.com/nwarila-platform/proxmox-terraform-framework/compare/v1.0.1...v2.0.0) (2026-05-12)


### ⚠ BREAKING CHANGES

* user_account removed from initialization block in tfvars. Inject credentials via TF_VAR_proxmox_cloud_init_user_name, TF_VAR_proxmox_cloud_init_user_password, and TF_VAR_proxmox_cloud_init_user_public_key environment variables.

### Features

* add .gitattributes for consistent line endings and language detection ([ae8f7b1](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/ae8f7b141d5b0f4f90e2e4b7e05d23328272c0ce))
* add reusable IaC security scan caller ([#24](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/24)) ([3ba8098](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/3ba80984e5e38f41ca8c74b4685674782a83e79f))
* **ci:** adopt pr-validation (contract-and-lint mode) ([#33](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/33)) ([80ecc59](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/80ecc593851b874771dfc10d4ffa09791d2895a3))
* **ci:** graduate to mode: full ([#41](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/41)) ([1557b7a](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/1557b7a7e1a20ba80b9ca1dbb5275d1217e759ba))
* **ci:** lint_advisory + bump to 1c92039 + prep renovate.json5 ([#34](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/34)) ([492af9b](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/492af9b07cfda3a7f9a01547ac38bad904fc50f8))
* complete contract scaffold + .gitignore allowlist ([#38](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/38)) ([788045e](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/788045e66f1cbdd680615baa792747c73b212298))
* consume reusable CodeQL workflow ([#31](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/31)) ([e0d8708](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/e0d870892d73714c23be5fdae4a914a3c9b45a84))
* contract scaffold + pin bump to ecb7a74 ([#28](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/28)) ([2799bce](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/2799bce5543794267c733b671c4737fd5be9ff59))
* enhance network device configuration with optional IPv4 prefix length ([d3d1c3f](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/d3d1c3f59c5761f7a79a61dcf924e51a22542775))
* implement dynamic initialization properties for virtual machines ([43cb0d3](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/43cb0d3fa08bc3be6fac6c613501ca3046926e79))
* move cloud-init credentials to top-level sensitive variables ([4ee7dc8](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/4ee7dc8c1edcaf744f82b20fa638a7129b5ee8cb))
* onboard NWarila/terraform-template@aeb3d18 (sync only) ([#18](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/18)) ([1d7d731](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/1d7d731b7309a08189e840096a4c1b5db6aced42))
* **security:** adopt OpenSSF Scorecard + bump pin to 9d354ff ([#45](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/45)) ([94eab58](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/94eab5888586554eb528e3cd4bb6c131fe18f7b6))
* **terraform:** allow persisted disks to attach on separate interface ([b9fa842](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/b9fa842900cb9759dc7df4aa1c00130e905f0b40))
* **terraform:** expose stable VM disk interfaces ([279b51e](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/279b51e95ae29970a52f1fd2d4f30b2450dc33ca))
* **terraform:** generate ansible inventory outputs ([ecfd2eb](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/ecfd2eb849829bb48517f437b885c35362c187b6))
* **terraform:** preserve persistent VM disks ([3fd01b8](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/3fd01b84daef5355181186a1d540163a6889fea5))


### Bug Fixes

* **ci:** drop forbidden *_advisory inputs on security caller ([#48](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/48)) ([f739bcc](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/f739bcc858e0ccb2bfa075a97538f7c3c367c1c0))
* **contract:** exact tf pins + SHA-pin actions + PR template casing ([#39](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/39)) ([3f80ce4](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/3f80ce40e32143ae420f05f6cde69d0aef96e463))
* **contract:** SHA-pin release-please-action ([#40](https://github.com/nwarila-platform/proxmox-terraform-framework/issues/40)) ([8ea973e](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/8ea973eed62984ff53b44ce94337175b5a9d3fde))
* **terraform:** tolerate unused missing templates ([07e39b1](https://github.com/nwarila-platform/proxmox-terraform-framework/commit/07e39b14eda046738e72df8ba9985e0d35c359ef))

## [1.0.1](https://github.com/NWarila/proxmox-terraform-framework/compare/v1.0.0...v1.0.1) (2026-03-09)


### Bug Fixes

* secure TLS default and document proxmox_skip_tls_verify ([fe7cc5f](https://github.com/NWarila/proxmox-terraform-framework/commit/fe7cc5fef13f91df0f2936227014a823224910e8))

## 1.0.0 (2026-03-09)


### Bug Fixes

* correct pip cache path and release-please action ref ([5f2cb69](https://github.com/NWarila/proxmox-terraform-framework/commit/5f2cb697f8d0cb9162c13e5fdc232c3a8bb8d9fa))
