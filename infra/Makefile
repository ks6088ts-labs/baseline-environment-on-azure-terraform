# Git
GIT_REVISION ?= $(shell git rev-parse --short HEAD)
GIT_TAG ?= $(shell git describe --tags --abbrev=0 | sed -e s/v//g)

# Azure CLI
SUBSCRIPTION_ID ?= $(shell az account show --query id --output tsv)
SUBSCRIPTION_NAME ?= $(shell az account show --query name --output tsv)
TENANT_ID ?= $(shell az account show --query tenantId --output tsv)
APPLICATION_ID ?= $(shell az ad sp list --display-name "baseline-environment-on-azure-terraform" --query "[0].appId" --output tsv)

# Terraform
SCENARIO ?= tfstate_backend
SCENARIO_DIR ?= scenarios/$(SCENARIO)
SCENARIO_DIR_LIST ?= $(shell find scenarios -maxdepth 1 -mindepth 1 -type d -print)
TERRAFORM ?= cd $(SCENARIO_DIR) && terraform

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
