# Configure GitHub Secrets

This is a scenario for configuring GitHub secrets.

## How to use

```shell
cd infra

# Set the variables
CREATE_GITHUB_REPOSITORY=true

APPLICATION_ID=$(az ad sp list --display-name "baseline-environment-on-azure-terraform" --query "[0].appId" --output tsv)
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
TENANT_ID=$(az account show --query tenantId --output tsv)

# Encode the variables
APPLICATION_ID=$(echo $APPLICATION_ID | base64)
SUBSCRIPTION_ID=$(echo $SUBSCRIPTION_ID | base64)
TENANT_ID=$(echo $TENANT_ID | base64)

# Create the tfvars file
SCENARIO="configure_github_secrets"
cat <<EOF > scenarios/$SCENARIO/terraform.tfvars
create_github_repository = true
organization = "ks6088ts-labs"
repository_name = "example-repository"
environment_name = "development"
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
