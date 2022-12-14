resource "azurerm_storage_account" "asa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  public_network_access_enabled = false
  is_hns_enabled           = true

  tags = {
    Project       = "Dataplatform"
    Project-Phase = "PoA"
    akosid        = "iot_sbx"
    service       = "StorageAccount"
  }
}

resource "azurerm_storage_container" "datalake" {
  count                 = length(var.container_names)
  name                  = element(var.container_names, count.index)
  storage_account_name  = azurerm_storage_account.asa.name
  container_access_type = "private"
}
