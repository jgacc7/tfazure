resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = [var.network_vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}
