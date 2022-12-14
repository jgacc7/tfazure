module "vm" {
  source = "./modules/vm"

  resource_group_name = azurerm_resource_group.rg_tf.name
  location            = azurerm_resource_group.rg_tf.location
  name                = "testoebb"
  subnet_id           = azurerm_subnet.datalake.id
}

resource "azurerm_subnet" "datalake" {
  name                                      = join("-", ["oebb", "datalake", var.env])
  resource_group_name                       = azurerm_resource_group.rg_tf.name
  virtual_network_name                      = azurerm_virtual_network.datafabrik.name
  address_prefixes                          = [var.snet_cidr]
  private_endpoint_network_policies_enabled = true
}

resource "azurerm_virtual_network" "datafabrik" {
  name                = join("-", ["vnet", "4", "idmp", var.env])
  address_space       = [var.vnet_cidr]
  location            = azurerm_resource_group.rg_tf.location
  resource_group_name = azurerm_resource_group.rg_tf.name
}

module "datalake" {
  source = "./modules/storage-account"

  resource_group_name  = azurerm_resource_group.rg_tf.name
  location             = azurerm_resource_group.rg_tf.location
  storage_account_name = join("", ["dataplatform4981", var.env])
  container_names      = ["01-ingest-area", "02-landing-area", "03-staging-area", "04-raw-vault", "05-business-vault", "06-data-products", "07-data-quality", "08-test-area", "09-archive", "99-test-outbound", "xx-logs"]
}

resource "azurerm_storage_data_lake_gen2_filesystem" "dppoa" {
  name               = join("-", ["dataplatform4981", "dfs", var.env])
  storage_account_id = module.datalake.storage_account_id
}

# module "synapse" {
#   source = "./modules/synapse"

#   resource_group_name    = azurerm_resource_group.rg_tf.name
#   location               = azurerm_resource_group.rg_tf.location
#   dfs_id                 = azurerm_storage_data_lake_gen2_filesystem.dppoa.id
#   synapse_workspace_name = join("-", ["dataplatform657", "workspace", var.env])
#   spark_pool_name        = join("", ["dppoa", var.env])
# }

# resource "azurerm_synapse_private_link_hub" "synapse-ui" {
#   name                = join("", ["synapse", "studio", var.env])
#   resource_group_name = azurerm_resource_group.rg_tf.name
#   location            = azurerm_resource_group.rg_tf.location
# }

module "pep_dns_blob" {
  source                         = "./modules/pep_dns"
  vnet_id                        = azurerm_virtual_network.datafabrik.id
  subnet_id                      = azurerm_subnet.datalake.id
  resource_group_name            = azurerm_resource_group.rg_tf.name
  location                       = azurerm_resource_group.rg_tf.location
  private_dns_zone_name          = "privatelink.blob.core.windows.net"
  name                           = join("-", ["oebb", "blob", var.env])
  private_connection_resource_id = module.datalake.storage_account_id
  subresource_names              = ["blob"]
}

# module "pep_dns_dfs" {
#   source                         = "./modules/pep_dns"
#   vnet_id                        = azurerm_virtual_network.datafabrik.id
#   subnet_id                      = azurerm_subnet.datalake.id
#   resource_group_name            = azurerm_resource_group.rg_tf.name
#   location                       = azurerm_resource_group.rg_tf.location
#   private_dns_zone_name          = "privatelink.dfs.core.windows.net"
#   name                           = join("-", ["oebb", "dfs", var.env])
#   private_connection_resource_id = module.datalake.storage_account_id
#   subresource_names              = ["dfs"]
# }

# module "pep_dns_synapse_dev" {
#   source                         = "./modules/pep_dns"
#   vnet_id                        = azurerm_virtual_network.datafabrik.id
#   subnet_id                      = azurerm_subnet.datalake.id
#   resource_group_name            = azurerm_resource_group.rg_tf.name
#   location                       = azurerm_resource_group.rg_tf.location
#   private_dns_zone_name          = "privatelink.dev.azuresynapse.net"
#   name                           = join("-", ["oebb", "synapse", "dev", var.env])
#   private_connection_resource_id = module.synapse.synapse-workspace-id
#   subresource_names              = ["Dev"]
# }

# module "pep_dns_synapse_sql" {
#   source                         = "./modules/pep_dns"
#   vnet_id                        = azurerm_virtual_network.datafabrik.id
#   subnet_id                      = azurerm_subnet.datalake.id
#   resource_group_name            = azurerm_resource_group.rg_tf.name
#   location                       = azurerm_resource_group.rg_tf.location
#   private_dns_zone_name          = "privatelink.sql.azuresynapse.net"
#   name                           = join("-", ["oebb", "synapse", "sql", var.env])
#   private_connection_resource_id = module.synapse.synapse-workspace-id
#   subresource_names              = ["SqlOnDemand"]
# }

# module "pep_dns_synapse_studio" {
#   source                         = "./modules/pep_dns"
#   vnet_id                        = azurerm_virtual_network.datafabrik.id
#   subnet_id                      = azurerm_subnet.datalake.id
#   resource_group_name            = azurerm_resource_group.rg_tf.name
#   location                       = azurerm_resource_group.rg_tf.location
#   private_dns_zone_name          = "privatelink.azuresynapse.net"
#   name                           = join("-", ["oebb", "synapse", "studio", var.env])
#   private_connection_resource_id = azurerm_synapse_private_link_hub.synapse-ui.id
#   subresource_names              = ["Web"]
# }


# locals {
#   private_dns_zone_names          = ["privatelink.blob.core.windows.net", "privatelink.dfs.core.windows.net", "privatelink.dev.azuresynapse.net", "privatelink.sql.azuresynapse.net", "privatelink.azuresynapse.net"]
#   names                           = [join("_", [var.storage_account_name, var.env]), join("-", ["oebb", "dfs", var.env]), join("-", ["oebb", "synapse", "dev", var.env]), join("-", ["oebb", "synapse", "sql", var.env]), join("-", ["oebb", "synapse", "studio", var.env])]
#   private_connection_resource_ids = [a, b, c, d, e]
#   subresource_names               = [[a], [b], [c], [d], [e]]
# }

# module "pep_dns" {
#   count                          = length(local.private_dns_zone_names)
#   source                         = "./modules/pep_dns"
#   vnet_id                        = azurerm_virtual_network.datafabrik.id
#   subnet_id                      = azurerm_subnet.datalake.id
#   resource_group_name            = azurerm_resource_group.rg_tf.name
#   location                       = azurerm_resource_group.rg_tf.location
#   private_dns_zone_name          = local.private_dns_zone_names[count.index]
#   name                           = local.names[count.index]
#   private_connection_resource_id = local.private_connection_resource_ids[count.index]
#   subresource_names              = local.subresource_names[count.index]
# }

resource "azurerm_resource_group" "rg_tf" {
  name = "rg_dp_test"
  location = "West Europe"
  
}

# data "azurerm_virtual_network" "hub-firewallvnet"{
#   name = "hub1-firewalvnet"
#   resource_group_name = "iotpoc_networks"
# }

# resource "azurerm_virtual_network_peering" "res-60" {
#   name                      = "spoke-to-hub-vnet-dataplatform"
#   remote_virtual_network_id = data.azurerm_virtual_network.hub-firewallvnet.id
#   resource_group_name       = "rg_dataplatform_poa"
#   virtual_network_name      = azurerm_virtual_network.datafabrik.name
# }