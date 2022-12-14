variable "resource_group_name" {
  description = " "
  type        = string
}

variable "location" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "network_vnet_cidr" {
  type        = string
  description = "The CIDR of the network VNET"
}