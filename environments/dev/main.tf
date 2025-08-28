
provider "azurerm" { 
  features {} 

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  }


locals {
prefix = "project-2-app-dev"
location = "northeurope"
}


resource "azurerm_resource_group" "rg" {
  name = "${local.prefix}-rg"
  location = local.location
}


module "network" {
  source = "../../modules/networking"
  name = "${local.prefix}-vnet"
  location = local.location
  rg_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]
  subnets = {
    app = {address_prefix = "10.0.1.0/24"}
    db = {address_prefix = "10.0.2.0/24"}
  }
}

module "compute" {
  source = "../../modules/compute"

  name        = "${local.prefix}-app"                # or local prefix
  location    = local.location
  rg_name     = azurerm_resource_group.rg.name
  runtime_stack = "NODE|20-lts"

  sku         = "P1v3"
  capacity  = 1

  autoscale_enabled        = true
  autoscale_min            = 1
  autoscale_default        = 1
  autoscale_max            = 3
  cpu_scale_out_threshold  = 70
  cpu_scale_in_threshold   = 30
  scale_cooldown           = 5
}


module "database" {
  admin_password = "DevPassword123"
  source = "../../modules/database"
  name = "${local.prefix}-db"
  location = local.location
  rg_name = azurerm_resource_group.rg.name

  sku_name   = "Standard_B1ms"
  storage_mb = 32768
}























