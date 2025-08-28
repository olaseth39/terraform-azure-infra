
# for Azure
variable "name" { 
    description = "Name of the Database"
    type = string 
}
variable "location" { 
    description = "Azure region where the Database will be created"
    type = string 
}
variable "rg_name" { 
    description = "Resource Group name where database resources will be created"
    type = string 
}
variable "sku_name" { 
    description = "SKU name for the Database"
    type = string 
    default = "B_Standard_B1ms" 
}
variable "storage_mb" { 
    description = "Storage size for the Database in MB"
    type = number 
    default = 32768 
}

variable "admin_login" {
  type        = string
  description = "Administrator username for the PostgreSQL server"
  default     = "pgadmin"
}

variable "admin_password" {
    description = "Administrator password for the Database"
    type = string
    sensitive = true
}