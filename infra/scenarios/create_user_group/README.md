# Create a new user and group in Microsoft Entra ID

This is a scenario for creating a new user and group in Microsoft Entra ID.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_user_group

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Destroy the infrastructure
terraform destroy -auto-approve
```

## References

### API Permissions

- [azuread_domains](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains#api-permissions)
- [azuread_user](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user#api-permissions)
- [azuread_group](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group#api-permissions)
- [azuread_group_member](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member#api-permissions)
