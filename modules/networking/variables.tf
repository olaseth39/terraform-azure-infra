
variable "name" { 
    description = "Name of the Virtual Network"
    type = string 
    }

variable "location" { 
    description = "Azure region where the VNet will be created"
    type = string 
    default = "northeurope"
    }

variable "rg_name" { 
    description = "Resource Group name where networking resources will be created"
    type = string 
    }

variable "address_space" { 
    type = list(string)
    default = ["10.0.0.0/16", "10.20.0.0/16"]
     }

variable "subnets" {
    type = map(object({ address_prefix = string }))
    default = {
    web = { address_prefix = "10.0.1.0/24" }
    backend = { address_prefix = "10.0.2.0/24"}
    }
}