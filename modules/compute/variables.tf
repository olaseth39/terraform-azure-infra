
# for AWS
# variable "vpc_id" {}
# variable "public_subnets" { type = list(string) }
# variable "private_subnets" { type = list(string) }
# variable "ami_id" {}
# variable "instance_type" { default = "t2.micro" }
# variable "alb_sg" {}

variable "name" {
  type = string
}

variable "location" {
  type    = string
  default = "northeurope"
}

variable "rg_name" {
  type = string
}

variable "runtime_stack" {
  type    = string
  default = "NODE|20-lts"
}

variable "sku" {
  type    = string
  default = "P1v3"
}

variable "capacity" {
  description = "Desired starting worker_count (will be used as default capacity if autoscale not enabled)."
  type        = number
  default     = 1
}

variable "autoscale_enabled" {
  description = "Enable autoscaling for this service plan?"
  type        = bool
  default     = false
}

variable "autoscale_min" {
  description = "Minimum worker count when autoscaling."
  type        = number
  default     = 1
}

variable "autoscale_default" {
  description = "Default worker count (initial) when autoscaling."
  type        = number
  default     = 1
}

variable "autoscale_max" {
  description = "Maximum worker count when autoscaling."
  type        = number
  default     = 5
}

variable "cpu_scale_out_threshold" {
  description = "CPU percent threshold to scale out."
  type        = number
  default     = 70
}

variable "cpu_scale_in_threshold" {
  description = "CPU percent threshold to scale in."
  type        = number
  default     = 30
}

variable "scale_cooldown" {
  description = "Cooldown period after a scale action (ISO 8601 duration)."
  type        = string
  default     = "PT5M"
}


