# Create a new user and group in Microsoft Entra ID

This is a scenario for creating a new user and group in Microsoft Entra ID.

## Deploy resources

```shell
# Go to the infra directory
cd infra

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Deploy infrastructure
make deploy SCENARIO="create_user_group"

# Destroy infrastructure
make destroy SCENARIO="create_user_group"
```

## API Permissions

- [azuread_domains](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains#api-permissions)
- [azuread_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user#api-permissions)
- [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#api-permissions)
- [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member#api-permissions)
