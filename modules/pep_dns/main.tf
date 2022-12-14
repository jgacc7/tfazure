resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link" {
  name                  = var.name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_private_dns_a_record" "dns_a" {
  name                = var.name
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pep.private_service_connection.0.private_ip_address]
}

resource "azurerm_private_endpoint" "pep" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = join("-", ["private", var.name])
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }
  private_dns_zone_group {
    name                 = azurerm_private_dns_zone.dns_zone.name
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
  }
}

