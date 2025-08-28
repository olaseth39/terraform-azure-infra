
# Azure
resource "azurerm_postgresql_flexible_server" "db" {
    name = var.name
    resource_group_name = var.rg_name
    location = var.location
    #sku_name = var.sku_name
    sku_name = "B_Standard_B1ms"
    storage_mb = var.storage_mb
    administrator_login = "pgadmin"
    administrator_password = var.admin_password
    version = "14"
}
