resource "azurerm_public_ip" "public_ip" {
  name                = format("%s_%s", var.name, "ip")
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "example" {
  name                = format("%s_%s", var.name, "network_interface")
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                = format("%s%s", var.name, "vm")
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B4ms"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  patch_mode = "AutomaticByPlatform" 

}

resource "azurerm_network_security_group" "nsg" {
  name                = format("%s_%s", var.name, "nsg")
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow_all_sg"
    priority                   = 100 
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_network_interface.example
  ]
}

resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}