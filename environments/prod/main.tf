provider "azurerm" { 
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}


locals {
prefix = "project-2-app-prod"
location = "northeurope"
}


resource "azurerm_resource_group" "rg" {
name = "${local.prefix}-rg"
location = local.location
}


module "network" {
  source  = "../../modules/networking"
  name    = "${local.prefix}-vnet"
  location = local.location
  rg_name  = azurerm_resource_group.rg.name
  address_space = ["10.0.0.0/16"]

  subnets = {
    web     = { address_prefix = "10.0.1.0/24" }
    backend = { address_prefix = "10.0.2.0/24" }
  }
}

module "compute" {
  source = "../../modules/compute"

  name        = local.prefix
  location    = local.location
  rg_name     = azurerm_resource_group.rg.name
  runtime_stack = "NODE|20-lts"

  # 💡 Production plan: Premium tier with autoscaling
  sku      = "P2v3"       # higher SKU than dev
  capacity = 2            # start with 2 workers

  # Autoscaling settings for production
  autoscale_enabled        = true
  autoscale_min            = 2
  autoscale_default        = 3
  autoscale_max            = 10
  cpu_scale_out_threshold  = 70   # scale out if avg CPU > 70%
  cpu_scale_in_threshold   = 30   # scale in if avg CPU < 30%
  scale_cooldown           = "PT5M"    # 5 minutes before another scale event
}



module "database" {
  source   = "../../modules/database"
  name     = "${local.prefix}-db"
  location = local.location
  rg_name  = azurerm_resource_group.rg.name

  sku_name       = "GP_Standard_D2s_v3" # larger for prod
  storage_mb     = 131072               # 128 GB
  admin_login    = "pgadmin"
  admin_password = var.admin_password # reference from Key Vault or tfvars
}


#  Action Group (email notification)
resource "azurerm_monitor_action_group" "alert_group" {
  name                = "${local.prefix}-alerts"
  resource_group_name = azurerm_resource_group.rg.name
  short_name          = "alerts"

  email_receiver {
    name          = "AdminEmail"
    email_address = "Abiola@snapnetsolutions.com"    
  }
}

#  CPU High Alert (scale out trigger monitor)
resource "azurerm_monitor_metric_alert" "cpu_high" {
  name                = "${local.prefix}-cpu-high"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.compute.app_service_plan_id] # reference App Service Plan ID
  description         = "Alert when CPU > 70% for 5 minutes"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 70
  }

  frequency   = "PT1M"   # check every 1 minute
  window_size = "PT5M"   # evaluate over last 5 minutes

  action {
    action_group_id = azurerm_monitor_action_group.alert_group.id
  }
}

# CPU Low Alert (scale in monitor)
resource "azurerm_monitor_metric_alert" "cpu_low" {
  name                = "${local.prefix}-cpu-low"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [module.compute.app_service_plan_id]
  description         = "Alert when CPU < 30% for 10 minutes"

  criteria {
    metric_namespace = "Microsoft.Web/serverfarms"
    metric_name      = "CpuPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 30
  }

  frequency   = "PT1M"
  window_size = "PT15M"

  action {
    action_group_id = azurerm_monitor_action_group.alert_group.id
  }
}





























