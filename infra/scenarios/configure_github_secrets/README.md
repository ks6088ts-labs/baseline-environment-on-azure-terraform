# Configure GitHub secrets

This is a scenario for configuring GitHub secrets.
There are several ways to configure GitHub secrets, such as ...

- [GitHub.com](https://github.com/)
- [GitHub REST API](https://docs.github.com/rest/actions/secrets)
- [GitHub CLI](https://cli.github.com/)
- [GitHub provider for Terraform](https://registry.terraform.io/providers/integrations/github/latest/docs)

## GitHub provider for Terraform

GitHub provider for Terraform is a plugin for Terraform that allows you to manage resources on GitHub. You can use the GitHub provider to manage repositories, organizations, teams, and more.

### How to use

```shell
# Move to the scenario directory
cd infra/scenarios/configure_github_secrets

# Authenticate with a GitHub host.
gh auth login

# (Optional) Display active account and authentication state on each known GitHub host.
gh auth status

# Create the tfvars file to override the default values.
cat <<EOF > terraform.tfvars
create_github_repository = "false"
organization = "ks6088ts-labs"
repository_name = "baseline-environment-on-azure-terraform"
environment_name = "tf"
actions_environment_secrets = [
    {
        name  = "HELLO"
        value = "HELLO"
    },
    {
        name  = "WORLD"
        value = "WORLD"
    },
]
EOF

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Destroy the infrastructure
terraform destroy -auto-approve
```

### Use cases

#### [Use GitHub Actions to connect to Azure](https://learn.microsoft.com/azure/developer/github/connect-from-azure?tabs=azure-portal%2Clinux)

Create `terraform.tfvars` file with the following content:

```shell
# Authenticate with Azure via Azure CLI
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Retrieve the required information.
APPLICATION_NAME="baseline-environment-on-azure-terraform_ci"
APPLICATION_ID=$(az ad sp list --display-name "$APPLICATION_NAME" --query "[0].appId" --output tsv)
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
TENANT_ID=$(az account show --query tenantId --output tsv)

# Create the tfvars file
cat <<EOF > terraform.tfvars
create_github_repository = "false"
organization = "ks6088ts-labs"
repository_name = "baseline-environment-on-azure-terraform"
environment_name = "tf"
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

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Destroy the infrastructure
terraform destroy -auto-approve
```

## GitHub CLI

If you want to configure GitHub secrets using GitHub CLI, you can see the [configure-github-secrets.sh](../../../scripts/configure-github-secrets.sh) script.
You can manage GitHub secrets using the GitHub CLI as shown in the script.

```shell
# Create a GitHub environment
# NOTE: Creating environment for repository using GitHub CLI is not supported yet, so we use the GitHub API directly.
# Here is the issue: https://github.com/cli/cli/issues/5149
gh api --method PUT -H "Accept: application/vnd.github+json" \
    repos/"$GITHUB_REPOSITORY"/environments/"$GITHUB_ENV_NAME"

# Set secrets for the environment
gh secret set --env "$GITHUB_ENV_NAME" ARM_CLIENT_ID --body "$APPLICATION_ID"
```

## References

- [Configure GitHub Secrets for authenticate with Azure via GitHub CLI: configure-github-secrets.sh](../../../scripts/configure-github-secrets.sh)
- [Conditional creation of a resource based on a variable in .tfvars](https://stackoverflow.com/a/60231673/4457856)
