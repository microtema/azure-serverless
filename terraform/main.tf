/*
// tag::azurerm_resource_group[]
resource "azurerm_resource_group" "this" {
  name     = "rg-${local.namespace}"
  location = var.location

  tags = local.tags
}
// end::azurerm_resource_group[]
*/

/*
// tag::azurerm_storage_account[]
resource "azurerm_storage_account" "this" {
  name                     = local.namespace_short
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags = local.tags
}
// end::azurerm_storage_account[]
*/

// tag::azurerm_application_insights[]
resource "azurerm_application_insights" "this" {
  name                = "insights-${local.namespace}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.this.name
  application_type    = "Node.JS"
}
// end::azurerm_application_insights[]

// tag::azurerm_app_service_plan[]
resource "azurerm_app_service_plan" "this" {
  name                = "plan-${local.namespace}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  kind                = "FunctionApp"
  reserved            = true # this has to be set to true for Linux. Not related to the Premium Plan
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  tags = local.tags
}
// end::azurerm_app_service_plan[]

// tag::archive_file[]
data "archive_file" "lib" {
  type        = "zip"
  source_dir  = "${path.module}/../dist"
  output_path = "${path.module}/../dist/${var.project}.zip"
}
// end::archive_file[]

// tag::azurerm_function_app[]
resource "azurerm_function_app" "this" {
  name                       = "app-${local.namespace}"
  resource_group_name        = data.azurerm_resource_group.this.name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.this.id
  storage_account_name       = data.azurerm_storage_account.this.name
  storage_account_access_key = data.azurerm_storage_account.this.primary_access_key
  version                    = "~3"
  os_type                    = "linux"
  app_settings               = {
    "FUNCTIONS_WORKER_RUNTIME"       = "node"
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key
  }
  site_config {
    linux_fx_version          = "node|14"
    use_32_bit_worker_process = false
  }
  tags = local.tags
}
// end::azurerm_function_app[]