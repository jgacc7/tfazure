# output "storage_ip_address" {
#   value = azurerm_private_endpoint.blob-endpoint.private_service_connection.*.private_ip_address
# }

# output "storage_dns_a_record" {
#   value = module.dns_blob.storage_dns_a_record
# }


# output "dfs_ip_address" {
#   value = azurerm_private_endpoint.dfs-endpoint.private_service_connection.*.private_ip_address
# }

# output "dfs_dns_a_record" {
#   value = azurerm_private_dns_a_record.dns_a.fqdn
# }

# output "vm_public_ip" {
#   value = module.vm.public_ip
# }