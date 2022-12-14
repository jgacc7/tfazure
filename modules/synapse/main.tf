resource "azurerm_synapse_workspace" "dppoa" {
  name                                 = var.synapse_workspace_name
  resource_group_name                  = var.resource_group_name
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = var.dfs_id
  managed_virtual_network_enabled      = true
  public_network_access_enabled        = false
  sql_administrator_login              = "sqladminuser"
  sql_administrator_login_password     = "H@Sh1CoR3!"

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Project       = "Dataplatform"
    Project-Phase = "PoA"
    akosid        = "iot_sbx"
    service       = "Synapase"
  }
}

resource "azurerm_synapse_spark_pool" "dppoa" {
  name                           = var.spark_pool_name
  synapse_workspace_id           = azurerm_synapse_workspace.dppoa.id
  node_size                      = "Medium"
  node_size_family               = "MemoryOptimized"
  cache_size                     = 100
  spark_version                  = "3.2"
  session_level_packages_enabled = true

  auto_pause {
    delay_in_minutes = 10
  }
  auto_scale {
    max_node_count = 10
    min_node_count = 3
  }

  library_requirement {
    content  = file("${path.module}/spark-packages.txt")
    filename = "packages.txt"
  }

  tags = {
    Project       = "Dataplatform"
    Project-Phase = "PoA"
    akosid        = "iot_sbx"
    service       = "SparkPool"
  }

}

