# Manage Microsoft Entra ID scenario

This is a scenario for describing how to manage Microsoft Entra ID using Terraform.

## Deployment

```shell
# Deploy users and groups
make deploy SCENARIO=manage_microsoft_entra_id

# Update `group_members.csv` with the newly created object id and run the deployment script again to add users to groups
make deploy SCENARIO=manage_microsoft_entra_id

# Clean up resources
make destroy SCENARIO=manage_microsoft_entra_id
```

## References

- [Manage Microsoft Entra ID users and groups](https://developer.hashicorp.com/terraform/tutorials/it-saas/entra-id)
- [Configuring a User or Service Principal for managing Azure Active Directory](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/guides/service_principal_configuration)
