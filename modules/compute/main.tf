# Service Plan
resource "azurerm_service_plan" "plan" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.rg_name
  os_type             = "Linux"
  sku_name            = var.sku
  worker_count        = var.capacity
}


# Linux Web App
resource "azurerm_linux_web_app" "app" {
  name                = "${var.name}-web"
  location            = var.location
  resource_group_name = var.rg_name
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    always_on = true

    application_stack {
      node_version   = startswith(var.runtime_stack, "NODE")   ? split("|", var.runtime_stack)[1] : null
      python_version = startswith(var.runtime_stack, "PYTHON") ? split("|", var.runtime_stack)[1] : null
      dotnet_version = startswith(var.runtime_stack, "DOTNET") ? split("|", var.runtime_stack)[1] : null
    }
  }

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE = "1"
  }
}


# Conditional autoscale setting (created only when autoscale_enabled = true)
resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count               = var.autoscale_enabled ? 1 : 0
  name                = "${var.name}-autoscale"
  location            = var.location
  resource_group_name = var.rg_name
  target_resource_id  = azurerm_service_plan.plan.id
  enabled             = true

  profile {
    name = "cpu-based"

    capacity {
      minimum = tostring(var.autoscale_min)
      maximum = tostring(var.autoscale_max)
      default = tostring(var.autoscale_default)
    }

    # Scale out rule (CPU > threshold)
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = var.cpu_scale_out_threshold
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = var.scale_cooldown
      }
    }

    # Scale in rule (CPU < threshold)
    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.plan.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT10M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = var.cpu_scale_in_threshold
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = var.scale_cooldown
      }
    }
  }
}











