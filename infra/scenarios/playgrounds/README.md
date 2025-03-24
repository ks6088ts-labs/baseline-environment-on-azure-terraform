# Playgrounds

This is a scenario for creating playgrounds for testing and experimenting with Terraform.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/playgrounds

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

## Use Azure Storage as the backend

Create a file named `backend.tf` with the following content. See [Example Backend Configurations](https://developer.hashicorp.com/terraform/language/backend/azurerm#example-backend-configurations) for more details.

```shell
# Copy the example backend configuration
cp backend.tf.example backend.tf

# Initialize the Terraform configuration.
terraform init

# Optionally, you can specify the backend configuration in the command line
terraform init \
  -backend-config="resource_group_name=rg-tfstatebackend-746a1" \
  -backend-config="storage_account_name=satfstatebackend746a1sa" \
  -backend-config="container_name=satfstatebackend746a1sc" \
  -backend-config="key=createresourcegroup.terraform.tfstate"
```

- [Store Terraform state in Azure Storage](https://learn.microsoft.com/azure/developer/terraform/store-state-in-azure-storage?tabs=terraform)

## Use Azure AI Foundry

### References

- [Quickstart: Create a new agent (Preview)](https://learn.microsoft.com/en-us/azure/ai-services/agents/quickstart?pivots=ai-foundry-portal)
- [Connect Azure OpenAI Service after you create a project](https://learn.microsoft.com/azure/ai-foundry/ai-services/how-to/connect-azure-openai#connect-azure-openai-service-after-you-create-a-project): Go to Management Center > Connected resources > New Connection > Azure AI services to connect to Azure AI services.
- [Azure OpenAI Service models](https://learn.microsoft.com/azure/ai-services/openai/concepts/models?tabs=global-standard%2Cstandard-chat-completions)
- [Grounding with Bing Search](https://learn.microsoft.com/en-us/azure/ai-services/agents/how-to/tools/bing-grounding?tabs=python&pivots=overview)

## Overwrite variables

```shell
cp terraform.tfvars.example terraform.tfvars

terraform apply -auto-approve
```

## Configure AKS cluster

```shell
# Set variables
RESOURCE_GROUP_NAME=$(terraform output -raw resource_group_name)
CLUSTER_NAME=$(terraform output -raw aks_cluster_name)

# Get the credentials for the AKS cluster
az aks get-credentials \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $CLUSTER_NAME \
  --verbose

# Port forward to a service
k -n argo-cd port-forward service/argo-cd-argocd-server 8080:443
k -n kube-prometheus-stack port-forward service/kube-prometheus-stack-grafana 8080:80

# Create ingress resource for Grafana
k -n kube-prometheus-stack apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-ingress
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: kube-prometheus-stack-grafana
                port:
                  number: 80
EOF

# Delete ingress resource for Grafana
k -n kube-prometheus-stack delete ingress test-ingress
```

### References

- [Installing kro on AKS with Terraform](https://carlos.mendible.com/2025/02/09/installing-kro-on-aks-with-terraform/)
- [ks6088ts-labs/workshop-kubernetes](https://github.com/ks6088ts-labs/workshop-kubernetes)
