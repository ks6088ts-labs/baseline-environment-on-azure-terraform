# Authenticate apps to Azure services during local development using service principals

## How to use

```shell
cd infra/scenarios/create_service_principal

# get current date in development_YYYYMMDD format
export TF_VAR_service_principal_name=$(date +"development_%Y%m%d")
# set the subscription id
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# deploy the infrastructure
terraform init
terraform apply -auto-approve
```

Retrieve parameters for the service principal.
Refer to [Authenticate Python apps to Azure services during local development using service principals > 4 - Set local development environment variables](https://learn.microsoft.com/azure/developer/python/sdk/authentication/local-development-service-principal?tabs=azure-cli#4---set-local-development-environment-variables) for more information.

```shell
export AZURE_CLIENT_ID=$(terraform output -raw service_principal_client_id)
export AZURE_TENANT_ID=$(terraform output -raw tenant_id)
export AZURE_CLIENT_SECRET=$(terraform output -raw service_principal_password)
```
