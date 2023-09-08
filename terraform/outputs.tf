output "resource_group_name" {
  value = data.azurerm_resource_group.this.name
}

output "function_app_name" {
  value       = azurerm_function_app.this.name
  description = "Deployed function app name"
}

output "function_app_default_hostname" {
  value       = "https://${azurerm_function_app.this.default_hostname}"
  description = "Deployed function app hostname"
}