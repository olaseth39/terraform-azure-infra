output "plan_id" {
  value = azurerm_service_plan.plan.id
}

output "web_app_hostname" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "autoscale_id" {
  value       = try(azurerm_monitor_autoscale_setting.autoscale[0].id, null)
  description = "Autoscale setting ID if autoscaling is enabled, null otherwise."
}

output "default_hostname" {
  description = "The default hostname of the web app"
  value       = azurerm_linux_web_app.app.default_hostname
}

output "app_id" {
  description = "The ID of the web app"
  value       = azurerm_linux_web_app.app.id
}

output "app_service_plan_id" {
  value = azurerm_service_plan.plan.id
}

