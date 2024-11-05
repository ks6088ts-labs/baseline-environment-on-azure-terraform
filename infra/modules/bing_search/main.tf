terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "2.0.1"
    }
  }
}

resource "azapi_resource" "bing_search" {
  type                      = "Microsoft.Bing/accounts@2020-06-10"
  schema_validation_enabled = false
  name                      = var.name
  parent_id                 = var.resource_group_id
  location                  = var.location
  body = {
    sku = {
      name = var.sku_name
    }
    kind = "Bing.Search.v7"
    tags = var.tags
  }
  response_export_values = ["*"]
}
