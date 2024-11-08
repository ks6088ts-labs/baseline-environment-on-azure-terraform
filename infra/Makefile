# Git
GIT_REVISION ?= $(shell git rev-parse --short HEAD)
GIT_TAG ?= $(shell git describe --tags --abbrev=0 | sed -e s/v//g)

# Azure CLI
SUBSCRIPTION_ID ?= $(shell az account show --query id --output tsv)
SUBSCRIPTION_NAME ?= $(shell az account show --query name --output tsv)
TENANT_ID ?= $(shell az account show --query tenantId --output tsv)
APPLICATION_ID ?= $(shell az ad sp list --display-name "baseline-environment-on-azure-terraform" --query "[0].appId" --output tsv)
RESOURCE_APP_ID ?= "00000003-0000-0000-c000-000000000000" # Microsoft Graph
PERMISSION_ID ?= "dbb9058a-0e50-45d7-ae91-66909b5d4664" # Domain.Read.All
PERMISSION_SCOPE ?= "Domain.Read.All"

# Terraform
SCENARIO ?= tfstate_backend
SCENARIO_DIR ?= scenarios/$(SCENARIO)
SCENARIO_DIR_LIST ?= $(shell find scenarios -maxdepth 1 -mindepth 1 -type d -print)
TERRAFORM ?= cd $(SCENARIO_DIR) && terraform
OUTPUT ?= resource_group_name

# GitHub
GITHUB_ORG ?= ks6088ts-labs
GITHUB_REPO ?= baseline-environment-on-azure-terraform
GITHUB_ENV ?= dev

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
.DEFAULT_GOAL := help

.PHONY: info
info: ## show information
	@echo "SUBSCRIPTION_ID: $(SUBSCRIPTION_ID)"
	@echo "SUBSCRIPTION_NAME: $(SUBSCRIPTION_NAME)"
	@echo "TENANT_ID: $(TENANT_ID)"
	@echo "GIT_REVISION: $(GIT_REVISION)"
	@echo "GIT_TAG: $(GIT_TAG)"

.PHONY: install-deps-dev
install-deps-dev: ## install dependencies for development
	@which terraform || echo "Please install Terraform: https://developer.hashicorp.com/terraform/install"
	@which tflint || echo "Please install tflint: https://github.com/terraform-linters/tflint#installation"
	@which tfsec || echo "Please install tfsec: https://aquasecurity.github.io/tfsec/v1.4.2/getting-started/installation/"

.PHONY: clear
clear:
	cd $(SCENARIO_DIR) && rm -rf .terraform*

.PHONY: init
init:
	$(TERRAFORM) init

.PHONY: lint
lint:
	$(TERRAFORM) fmt -check
	$(TERRAFORM) validate

.PHONY: tflint
tflint:
	@if [ -x "$(shell command -v tflint)" ]; then \
		echo "Running tflint..."; \
		tflint --init; \
		tflint --recursive; \
	else \
		echo "tflint is not installed. Skipping..."; \
	fi

.PHONY: tfsec
tfsec:
	@if [ -x "$(shell command -v tfsec)" ]; then \
		echo "Running tfsec..."; \
		tfsec .; \
	else \
		echo "tfsec is not installed. Skipping..."; \
	fi

.PHONY: format
format: ## format terraform codes
	$(TERRAFORM) fmt -recursive

.PHONY: plan
plan:
	$(TERRAFORM) plan

.PHONY: test
test: init ## test codes
	$(TERRAFORM) test

.PHONY: _ci-test-base
_ci-test-base: install-deps-dev clear init lint test plan

.PHONY: ci-test
ci-test: tflint tfsec ## ci test
	@for dir in $(SCENARIO_DIR_LIST) ; do \
		echo "Test: $$dir" ; \
		make _ci-test-base SCENARIO=$$(basename $$dir) || exit 1 ; \
	done

.PHONY: deploy
deploy: init ## deploy resources
	$(TERRAFORM) apply -auto-approve

.PHONY: destroy
destroy: init ## destroy resources
	$(TERRAFORM) destroy -auto-approve

.PHONY: output
output: ## get output
	@$(TERRAFORM) output $(OUTPUT)

.PHONY: gh-create-env
gh-create-env: ## create environment on GitHub
	# FIXME: https://github.com/cli/cli/issues/5149
	# https://stackoverflow.com/a/71388564/4457856
	gh api --method PUT -H "Accept: application/vnd.github+json" \
		repos/$(GITHUB_ORG)/$(GITHUB_REPO)/environments/$(GITHUB_ENV)

.PHONY: gh-set-secrets
gh-set-secrets: ## set secrets on GitHub
	gh secret set --env $(GITHUB_ENV) ARM_CLIENT_ID       --body $(APPLICATION_ID)
	gh secret set --env $(GITHUB_ENV) ARM_SUBSCRIPTION_ID --body $(SUBSCRIPTION_ID)
	gh secret set --env $(GITHUB_ENV) ARM_TENANT_ID       --body $(TENANT_ID)
	gh secret set --env $(GITHUB_ENV) ARM_USE_OIDC        --body "true"

.PHONY: ad-app-permission-add
ad-app-permission-add: ## add permission to the application
	az ad app permission add \
		--id $(APPLICATION_ID) \
		--api $(RESOURCE_APP_ID) \
		--api-permissions $(PERMISSION_ID)=Role

.PHONY: ad-app-permission-admin-consent
ad-app-permission-admin-consent: ## admin consent to the application
	az ad app permission admin-consent \
		--id $(APPLICATION_ID)
