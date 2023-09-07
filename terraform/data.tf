data "azurerm_resource_group" "this" {
  name     = "rg-${local.namespace}"
}

data "azurerm_storage_account" "this" {
  name     = local.namespace_short
  resource_group_name      = data.azurerm_resource_group.this.name
}