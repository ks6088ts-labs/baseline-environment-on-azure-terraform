[![test](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/test.yml?query=branch%3Amain)
[![deploy](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/deploy.yml/badge.svg?branch=main)](https://github.com/ks6088ts-labs/baseline-environment-on-azure-terraform/actions/workflows/deploy.yml?query=branch%3Amain)

# baseline-environment-on-azure-terraform

Baseline Environment on Azure in Terraform is a set of reference Terraform template

## Prerequisites

- [GNU Make](https://www.gnu.org/software/make/)
- [Terraform](https://github.com/Azure/azure-cli#installation) 1.6 or later

## Usage

See [Makefile](./infra/Makefile) for details.

```shell
❯ cd infra; make help
ci-test                        ci test
configure-github-secrets       configure GitHub secrets
create-for-rbac                create service principal for RBAC
deploy                         deploy resources
destroy                        destroy resources
format                         format terraform codes
info                           show information
install-deps-dev               install dependencies for development
test                           test codes
```

## Scenarios

| Scenario                                                                       | Overview                                        |
| ------------------------------------------------------------------------------ | ----------------------------------------------- |
| [tfstate_backend](./infra/scenarios/tfstate_backend/README.md)                 | Create Terraform state backend in Azure Storage |
| [development_environment](./infra/scenarios/development_environment/README.md) | Development environment                         |
| [workshop_azure_openai](./infra/scenarios/workshop_azure_openai/README.md)     | Workshop Azure OpenAI                           |
