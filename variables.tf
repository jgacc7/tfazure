variable "resource_group_name" {
  type    = string
  default = "oebb_infra_data_platform"
}
variable "location" {
  type    = string
  default = "West Europe"
}

variable "env" {
  type        = string
  description = "this variable controls deployment environment and takes value from dev test prod"
  validation {
    condition     = var.env == "dev" || var.env == "test" || var.env == "prod"
    error_message = "The env variable must be set to dev, test or prod."
  }
}

variable "vnet_cidr" {
  type = string
  default = "10.1.8.0/26"
}

variable "snet_cidr" {
  type = string
  default = "10.1.8.0/26"
}
