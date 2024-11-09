#!/bin/sh

set -eux

GITHUB_ENV_NAME="dev2"
APPLICATION_ID=$(az ad sp list --display-name "baseline-environment-on-azure-terraform" --query "[0].appId" --output tsv)
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
TENANT_ID=$(az account show --query tenantId --output tsv)

echo "APPLICATION_ID: $APPLICATION_ID"
echo "SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo "TENANT_ID: $TENANT_ID"

# Create a new environment
# https://github.com/cli/cli/issues/5149
# https://stackoverflow.com/a/71388564/4457856
gh api --method PUT -H "Accept: application/vnd.github+json" \
    repos/ks6088ts-labs/baseline-environment-on-azure-terraform/environments/"$GITHUB_ENV_NAME"

# Set secrets for the environment
gh secret set --env "$GITHUB_ENV_NAME" ARM_CLIENT_ID       --body "$APPLICATION_ID"
gh secret set --env "$GITHUB_ENV_NAME" ARM_SUBSCRIPTION_ID --body "$SUBSCRIPTION_ID"
gh secret set --env "$GITHUB_ENV_NAME" ARM_TENANT_ID       --body "$TENANT_ID"
gh secret set --env "$GITHUB_ENV_NAME" ARM_USE_OIDC        --body "true"