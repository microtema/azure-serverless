terraform {
  required_version = ">=1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

    backend "azurerm" {
      resource_group_name  = "rg-microtema-dev-westeurope-07"
      storage_account_name = "microtemadevwesteurope07"
      container_name       = "scm-releases"
      key                  = "terraform-state.json"
    }
}
provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}