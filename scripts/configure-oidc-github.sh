#!/bin/sh

set -eux

# Use GitHub Actions to connect to Azure:
# https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure?tabs=azure-cli%2Clinux

# get the directory of the script
SCRIPT_DIR=$(cd "$(dirname "$0")" || exit; pwd)

# get the name of the current directory
appName=test-$(basename "$(pwd)")

# Azure sign in
az login

# Get the current Azure subscription ID
subscriptionId=$(az account show --query 'id' --output tsv)

# Create a new Azure Active Directory application
appId=$(az ad app create --display-name "$appName" --query appId --output tsv)

# Create a new service principal for the application
assigneeObjectId=$(az ad sp create --id "$appId" --query id --output tsv)

# Get the tenant ID of the Azure subscription
tenantId=$(az ad sp show --id "$appId" --query appOwnerOrganizationId --output tsv)

# Assign the 'Contributor' role to the service principal for the subscription
az role assignment create --role contributor \
    --subscription "$subscriptionId" \
    --assignee-object-id "$assigneeObjectId" \
    --assignee-principal-type ServicePrincipal \
    --scope /subscriptions/"$subscriptionId"

# Assign the 'Contributor' role to the service principal for the subscription
az ad app federated-credential create \
    --id "$appId" \
    --parameters "$SCRIPT_DIR"/credential.json

# Dump parameters to the console
echo "AZURE_CLIENT_ID: $appId"
echo "AZURE_SUBSCRIPTION_ID: $subscriptionId"
echo "AZURE_TENANT_ID: $tenantId"

# Verify gh is installed
if ! command -v gh >/dev/null 2>&1
then
    echo "GitHub CLI (gh) could not be found"
    echo "Please install gh: https://cli.github.com/"
    exit
fi

# Register secrets on GitHub (NOTE: create dev environment before running this)
gh secret set ARM_CLIENT_ID --body $appId --env dev
gh secret set ARM_SUBSCRIPTION_ID --body $subscriptionId --env dev
gh secret set ARM_TENANT_ID --body $tenantId --env dev
gh secret set ARM_USE_OIDC --body "true" --env dev