terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
}

locals {
  ai_services_name = "aoai${var.name}${module.random.random_string}"
}

module "random" {
  source = "../../modules/random"

  length  = 5
  special = false
  upper   = false
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = "rg-${var.name}-${module.random.random_string}"
  location = var.location
  tags     = var.tags
}

module "aks" {
  source              = "../../modules/aks"
  name                = "aks${var.name}${module.random.random_string}"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}

resource "helm_release" "ingress_nginx" {
  count = var.create_ingress_nginx ? 1 : 0

  create_namespace = true
  name             = "ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  version          = "4.12.0"
  repository       = "https://kubernetes.github.io/ingress-nginx"

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path"
    value = "/healthz"
  }

  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
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
