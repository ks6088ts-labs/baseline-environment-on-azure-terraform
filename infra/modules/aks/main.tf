terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.22.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre1"
    }
  }
}

resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.name
  location            = var.location
  tags                = var.tags
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }
}

resource "helm_release" "ingress_nginx" {
  count = var.create_ingress_nginx ? 1 : 0

  create_namespace = true
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "4.12.0"
  repository       = "https://kubernetes.github.io/ingress-nginx"

  set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
      value = "/healthz"
    },
    {
      name  = "controller.service.externalTrafficPolicy"
      value = "Local"
    },
  ]
}

resource "helm_release" "kube_prometheus_stack" {
  count = var.create_kube_prometheus_stack ? 1 : 0

  create_namespace = true
  name             = "kube-prometheus-stack"
  chart            = "kube-prometheus-stack"
  namespace        = "kube-prometheus-stack"
  version          = "69.1.1"
  repository       = "https://prometheus-community.github.io/helm-charts"
}

resource "helm_release" "argo_cd" {
  count = var.create_argo_cd ? 1 : 0

  create_namespace = true
  name             = "argo-cd"
  chart            = "argo-cd"
  namespace        = "argo-cd"
  version          = "7.8.2"
  repository       = "https://argoproj.github.io/argo-helm"
}

resource "helm_release" "argo_workflows" {
  count = var.create_argo_workflows ? 1 : 0

  create_namespace = true
  name             = "argo-workflows"
  chart            = "argo-workflows"
  namespace        = "argo-workflows"
  version          = "0.45.4"
  repository       = "https://argoproj.github.io/argo-helm"
}

resource "helm_release" "open_webui" {
  count = var.create_open_webui ? 1 : 0

  create_namespace = true
  name             = "open-webui"
  chart            = "open-webui"
  namespace        = "open-webui"
  version          = "5.10.0"
  repository       = "https://open-webui.github.io/helm-charts"
}

resource "helm_release" "kubecost" {
  count = var.create_kubecost ? 1 : 0

  create_namespace = true
  name             = "kubecost"
  chart            = "cost-analyzer"
  namespace        = "kubecost"
  version          = "2.6.2"
  repository       = "https://kubecost.github.io/cost-analyzer"
}
