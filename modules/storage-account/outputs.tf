output "storage_account_name" {
  value = azurerm_storage_account.asa.name
}
output "storage_account_id" {
  value = azurerm_storage_account.asa.id
}
output "container_ids" {
  value = azurerm_storage_container.datalake[*].id
}
