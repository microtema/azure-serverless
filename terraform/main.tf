// tag::azurerm_resource_group[]
resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project}-${var.env}-${var.location}-${var.counter}"
  location = var.location
}
// end::azurerm_resource_group[]

// tag::azurerm_storage_account[]
resource "azurerm_storage_account" "storage_account" {
  name                     = "storage-${var.project}-${var.env}-${var.location}-${var.counter}"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
// end::azurerm_storage_account[]

// tag::azurerm_application_insights[]
resource "azurerm_application_insights" "this" {
  name                = "insights-${var.project}-${var.env}-${var.location}-${var.counter}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "Node.JS"
}
// end::azurerm_application_insights[]

// tag::azurerm_app_service_plan[]
resource "azurerm_app_service_plan" "this" {
  name                = "plan-${var.project}-${var.env}-${var.location}-${var.counter}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  kind                = "FunctionApp"
  reserved            = true # this has to be set to true for Linux. Not related to the Premium Plan
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
// end::azurerm_app_service_plan[]

// tag::azurerm_app_service_plan[]
resource "azurerm_function_app" "this" {
  name                = "app-${var.project}-${var.env}-${var.location}-${var.counter}"
  resource_group_name = azurerm_resource_group.this.name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.this.id
  app_settings        = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "",
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key,
  }
  os_type = "linux"
  site_config {
    linux_fx_version          = "node|14"
    use_32_bit_worker_process = false
  }
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  version                    = "~3"

  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
}
// end::azurerm_app_service_plan[]