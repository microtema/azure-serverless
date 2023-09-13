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
    WEBSITE_RUN_FROM_PACKAGE       = "1"
    FUNCTIONS_WORKER_RUNTIME       = "node"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.this.instrumentation_key
    AzureWebJobsStorage            = data.azurerm_storage_account.this.primary_blob_connection_string
  }
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"]
    ]
  }

  # FIXME: Use DNS names instead of enabling CORS
  site_config {
    cors {
      allowed_origins = ["*"]
    }
  }
  tags = local.tags
}
// end::azurerm_function_app[]