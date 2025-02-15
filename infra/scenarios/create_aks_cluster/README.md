# Create AKS cluster

This is a scenario for describing how to create Azure Kubernetes Service (AKS) clusters.

## How to use

```shell
# Move to the scenario directory
cd infra/scenarios/create_aks_cluster

# Log in to Azure
az login

# (Optional) Confirm the details for the currently logged-in user
az ad signed-in-user show

# Set environment variables
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)

# Set the feature flag to create resources
# export TF_VAR_create_container_app="true"

# Initialize the Terraform configuration.
terraform init

# Deploy the infrastructure
terraform apply -auto-approve

# Destroy the infrastructure
terraform destroy -auto-approve
```

Customize the `terraform.tfvars` file to override the default values.

```shell
cat <<EOF > terraform.tfvars
create_ingress_nginx = true
create_kubecost = true
EOF
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
NAMESPACE=argo-cd
SERVICE_NAME=$NAMESPACE-argocd-server
PORT=443
k -n $NAMESPACE port-forward service/$SERVICE_NAME 8080:$PORT
k -n argo-workflows port-forward service/argo-workflows-server 8080:2746
k -n kube-prometheus-stack port-forward service/kube-prometheus-stack-grafana 8080:80
k -n open-webui port-forward service/open-webui 8080:80

# Grafana の Ingress リソースの作成

# kube-prometheus-stack
NAMESPACE=kube-prometheus-stack
SERVICE_NAME=kube-prometheus-stack-grafana
PORT=80

INGRESS_NAME=test-ingress
k -n $NAMESPACE apply -f - <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: $INGRESS_NAME
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: /
            backend:
              service:
                name: $SERVICE_NAME
                port:
                  number: $PORT
EOF

# Ingress リソースの削除
k -n $NAMESPACE delete ingress $INGRESS_NAME
```

## References

- [Installing kro on AKS with Terraform](https://carlos.mendible.com/2025/02/09/installing-kro-on-aks-with-terraform/)
- [ks6088ts-labs/workshop-kubernetes](https://github.com/ks6088ts-labs/workshop-kubernetes)
