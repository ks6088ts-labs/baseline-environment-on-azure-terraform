# Configure GitHub Secrets

This is a scenario for configuring GitHub secrets.

## How to use

```shell
# Authenticate with a GitHub host.
gh auth login

cd infra

# Set the variables
CREATE_GITHUB_REPOSITORY=false
ENVIRONMENT=ci

APPLICATION_ID=$(az ad sp list --display-name "baseline-environment-on-azure-terraform_$ENVIRONMENT" --query "[0].appId" --output tsv)
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
TENANT_ID=$(az account show --query tenantId --output tsv)

# Create the tfvars file
SCENARIO="configure_github_secrets"
cat <<EOF > scenarios/$SCENARIO/terraform.tfvars
create_github_repository = "$CREATE_GITHUB_REPOSITORY"
organization = "ks6088ts-labs"
repository_name = "baseline-environment-on-azure-terraform"
environment_name = "$ENVIRONMENT"
actions_environment_secrets = [
    {
        name  = "ARM_CLIENT_ID"
        value = "$APPLICATION_ID"
    },
    {
        name  = "ARM_SUBSCRIPTION_ID"
        value = "$SUBSCRIPTION_ID"
    },
    {
      name  = "ARM_TENANT_ID"
      value = "$TENANT_ID"
    },
    {
      name  = "ARM_USE_OIDC"
      value = "true"
    },
]
EOF

# Deploy the infrastructure
make deploy SCENARIO=$SCENARIO

# Destroy the infrastructure
make destroy SCENARIO=$SCENARIO
```

## References

- [Conditional creation of a resource based on a variable in .tfvars](https://stackoverflow.com/a/60231673/4457856)
