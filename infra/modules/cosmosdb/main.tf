terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.5.0"
    }
  }
}

resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                       = "${var.name}cosmosdb"
  location                   = var.location
  tags                       = var.tags
  resource_group_name        = var.resource_group_name
  offer_type                 = "Standard"
  kind                       = "GlobalDocumentDB"
  automatic_failover_enabled = false

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  capabilities {
    name = "EnableNoSQLVectorSearch"
  }
}

resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = "${var.name}sqldb"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb_account.name
  throughput          = var.throughput
}

resource "azurerm_cosmosdb_sql_container" "cosmosdb_sql_container" {
  name                  = "${var.name}sqlcontainer"
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmosdb_account.name
  database_name         = azurerm_cosmosdb_sql_database.cosmosdb_sql_database.name
  partition_key_version = 1
  throughput            = var.throughput

  partition_key_paths = [
    "/id"
  ]
}
