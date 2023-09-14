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
  storage_account_name       = data.azurerm_storage_account.this.name
  location                   = var.location
  app_service_plan_id        = azurerm_app_service_plan.this.id
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

    linux_fx_version = "Node|14"
  }

  tags = local.tags
}
// end::azurerm_function_app[]

// tag::azurerm_cosmosdb_account[]
resource "azurerm_cosmosdb_account" "this" {
  name                = "account-${local.namespace}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = var.location
  offer_type          = "Standard"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  tags = local.tags
}

resource "azurerm_cosmosdb_sql_database" "this" {
  name                = "db-${local.namespace}"
  resource_group_name = data.azurerm_resource_group.this.name
  account_name        = azurerm_cosmosdb_account.this.name
}
// end::azurerm_cosmosdb_account[]

// tag::azurerm_cosmosdb_sql_container[]
resource "azurerm_cosmosdb_sql_container" "this" {
  name                  = "container-${local.namespace}"
  resource_group_name   = data.azurerm_resource_group.this.name
  account_name          = azurerm_cosmosdb_account.this.name
  database_name         = azurerm_cosmosdb_sql_database.this.name
  partition_key_path    = "/definition/id"
  partition_key_version = 1
  throughput            = 400

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }

    included_path {
      path = "/included/?"
    }

    excluded_path {
      path = "/excluded/?"
    }
  }

  unique_key {
    paths = ["/cid"]
  }
}
// end::azurerm_cosmosdb_sql_container[]



