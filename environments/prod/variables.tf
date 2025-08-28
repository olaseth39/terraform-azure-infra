variable "subscription_id" {
  description = "The Azure subscription ID"
  type        = string
  default     = ""
}


variable "tenant_id" {
  description = "The Azure tenant ID"
  type        = string
  default     = ""
}


variable "client_id" {
    description = "The Azure client ID"
    type        = string
    default     = ""
}


variable "client_secret" {
    description = "The Azure client secret"
    type        = string
    sensitive   = true
}


variable "admin_password" {
  description = "Database admin password"
  type        = string
  sensitive   = true
}
