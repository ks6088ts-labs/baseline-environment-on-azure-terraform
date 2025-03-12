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

provider "azurerm" {
  features {}
}

provider "helm" {
  kubernetes = {
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

module "ai_services" {
  for_each = { for ai_services_deployment in var.ai_services_deployments : ai_services_deployment.location => ai_services_deployment }

  source                = "../../modules/ai_services"
  name                  = "${local.ai_services_name}${each.value.location}"
  location              = each.value.location
  resource_group_name   = module.resource_group.name
  sku_name              = "S0"
  tags                  = var.tags
  deployments           = each.value.deployments
  custom_subdomain_name = "${local.ai_services_name}${each.value.location}"
}

module "aks" {
  source              = "../../modules/aks"
  name                = "aks${var.name}${module.random.random_string}"
  location            = var.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
  node_count          = var.aks_node_count

  create_ingress_nginx         = true
  create_argo_cd               = true
  create_kube_prometheus_stack = true
}

module "container_app_environment" {
  source              = "../../modules/container_app_environment"
  name                = var.name
  location            = var.location
  tags                = var.tags
  resource_group_name = module.resource_group.name
}

module "container_app" {
  source                       = "../../modules/container_app"
  name                         = var.name
  tags                         = var.tags
  image                        = var.container_app_image
  resource_group_name          = module.resource_group.name
  ingress_target_port          = var.container_app_ingress_target_port
  envs                         = var.container_app_envs
  container_app_environment_id = module.container_app_environment.id
}
