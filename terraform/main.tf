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
  source_dir  = "${path.module}/../"
  output_path = "${path.module}/../lib/${var.project}.zip"
}
// end::archive_file[]

// tag::azurerm_storage_blob[]
resource "azurerm_storage_blob" "lib" {
  name                   = "${filesha256(data.archive_file.lib.output_path)}.zip"
  storage_account_name   = data.azurerm_storage_account.this.name
  storage_container_name = data.azurerm_storage_container.this.name
  type                   = "Block"
  source                 = data.archive_file.lib.output_path
}
// tag::azurerm_storage_blob[]

// tag::azurerm_storage_account_blob_container_sas[]
data "azurerm_storage_account_blob_container_sas" "this" {
  connection_string = data.azurerm_storage_account.this.primary_connection_string
  container_name    = data.azurerm_storage_container.this.name

  start  = "2023-09-01T00:00:00Z"
  expiry = "2024-01-01T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}
// end::azurerm_storage_account_blob_container_sas[]

// tag::azurerm_function_app[]
resource "azurerm_function_app" "this" {
  name                = "app-${local.namespace}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.this.id
  app_settings        = {
    "WEBSITE_RUN_FROM_PACKAGE"       = "https://${data.azurerm_storage_account.this.name}.blob.core.windows.net/${data.azurerm_storage_container.this.name}/${azurerm_storage_blob.lib.name}${data.azurerm_storage_account_blob_container_sas.this.sas}",
    "FUNCTIONS_WORKER_RUNTIME"       = "node",
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.this.instrumentation_key,
    "AzureWebJobsDisableHomepage"    = "true"
  }
  os_type = "linux"
  site_config {
    linux_fx_version          = "node|14"
    use_32_bit_worker_process = false
  }
  storage_account_name       = data.azurerm_storage_account.this.name
  storage_account_access_key = data.azurerm_storage_account.this.primary_access_key
  version                    = "~3"

  /*
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
    ]
  }
  */
  tags = local.tags
}
// end::azurerm_function_app[]