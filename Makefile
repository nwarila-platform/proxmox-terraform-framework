PYTHON ?= python3
TERRAFORM_TEST_JSON ?= .tmp/opa-plan/terraform-test.jsonl

# Mutating: rewrites HCL in place. Use locally before committing.
fmt:
	terraform -chdir=terraform fmt -recursive

# Non-mutating: fails if any file would change. Use in CI.
fmt-check:
	terraform -chdir=terraform fmt -check -recursive

init:
	terraform -chdir=terraform init -backend=false -input=false

validate:
	terraform -chdir=terraform validate

test:
	mkdir -p .tmp/opa-plan
	terraform -chdir=terraform test -json -verbose > $(TERRAFORM_TEST_JSON)

# Mutating: regenerates the injected block in docs/reference/terraform.md.
docs:
	terraform-docs --config .terraform-docs.yml terraform

# Non-mutating: fails if docs/reference/terraform.md is out of sync with terraform/.
docs-diff:
	terraform-docs --config .terraform-docs.yml --output-check terraform

docs-check:
	$(PYTHON) tools/check_docs_layout.py

tflint:
	tflint --chdir=terraform

opa-test:
	opa test policies/opa

opa-plan:
	mkdir -p .tmp/opa-plan
	test -s $(TERRAFORM_TEST_JSON) || terraform -chdir=terraform test -json -verbose > $(TERRAFORM_TEST_JSON)
	$(PYTHON) tools/build_plan_input.py < $(TERRAFORM_TEST_JSON) | opa eval --fail-defined --format pretty --stdin-input --data policies/opa 'data.terraform_plan.deny[_]'

ci:
	$(MAKE) fmt-check
	$(MAKE) init
	$(MAKE) validate
	$(MAKE) test
	$(MAKE) tflint
	$(MAKE) docs-diff
	$(MAKE) docs-check
	$(MAKE) opa-test
	$(MAKE) opa-plan
