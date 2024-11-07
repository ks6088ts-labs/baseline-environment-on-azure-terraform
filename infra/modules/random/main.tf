terraform {
  required_version = ">= 1.6.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}

resource "random_string" "string" {
  length  = var.length
  special = var.special
  upper   = var.upper
}
